
import 'package:intl/intl.dart';

class Note {
  int? id;
  String title;
  String name;
  String location;
  String event;
  int? color;
  DateTime date;

  Note({
    this.id,
    required this.title,
    required this.name,
    required this.location,
    required this.event,
    this.color,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date); // Include time
    return {
      'id': id,
      'title': title,
      'name': name,
      'location': location,
      'event': event,
      'color': color,
      'date': formattedDate,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      name: map['name'],
      location: map['location'],
      event: map['event'],
      color: map['color'],
      date: DateTime.parse(map['date']),
    );
  }

  Note withDate(DateTime newDate) {
    return Note(
      id: id,
      title: title,
      name: name,
      event: event,
      location: location,
      color: color,
      date: newDate,
    );
  }
}
