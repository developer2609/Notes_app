
import 'package:notes_app/data/model/notes_model.dart';

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoadInProgress extends NoteState {}

class NoteLoadSuccess extends NoteState {
  final List<Note> notes;

  NoteLoadSuccess(this.notes);
}

class NoteLoadFailure extends NoteState {
  final String errorMessage;
  NoteLoadFailure({required this.errorMessage});
}