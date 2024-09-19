import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/presentation/blocs/note_bloc.dart';
import 'package:notes_app/presentation/pages/home_page.dart';
import 'data/database/database_helper.dart';


void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final databaseHelper = DatabaseHelper.instance;

    return BlocProvider(
      create: (context) => NoteBloc(databaseHelper),
      child: MaterialApp(
        debugShowCheckedModeBanner: false
        ,
        title: 'Event Calendar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CustomCalendar(),
      ),
    );
  }
}
