import 'dart:async';

import 'package:intl/intl.dart';
import 'package:notes_app/data/model/notes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "events.db";
  static final _databaseVersion = 1;

  static final table = 'notes';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnName = 'name';
  static final columnColor = 'color';
  static final columnLocation = 'location';
  static final columnevet = 'event';
  static final columnDate = 'date';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  final _updateController = StreamController<void>.broadcast();
  Stream<void> get updateStream => _updateController.stream;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    print("Database path: $path");

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      $columnTitle TEXT NOT NULL,
      $columnDate TEXT NOT NULL,
      $columnName TEXT NOT NULL,
      $columnevet TEXT NOT NULL,
      $columnLocation TEXT NOT NULL,
      $columnColor INTEGER
    )
  ''');
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    try {
      await db.insert(
        table,
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _updateController.add(null);

      print('Note successfully inserted.');
    } catch (e) {
      print('Error inserting note: $e');
    }


  }
  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      table,
      note.toMap(),
      where: '$columnId = ?',
      whereArgs: [note.id],
    );
    _updateController.add(null);

  }
  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    _updateController.add(null);

  }


  Future<List<Note>> getNotesByDate(DateTime date) async {
    final db = await database;
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: [columnId, columnTitle, columnDate, columnColor, columnName, columnLocation,columnevet],
      where: 'strftime("%Y-%m-%d", $columnDate) = ?',
      whereArgs: [formattedDate],
    );

    print("Filtered notes by date $formattedDate: $maps");
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i][columnId],
        title: maps[i][columnTitle],
        date: DateTime.parse(maps[i][columnDate]),
        name: maps[i][columnName],
        location: maps[i][columnLocation],

        color: maps[i][columnColor], event:maps[i][columnevet] ,
      );
    });
  }
  Future<void> close() async {
    await _updateController.close();
    _database?.close();
  }


}
