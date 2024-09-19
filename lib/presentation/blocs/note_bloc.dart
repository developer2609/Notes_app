import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database/database_helper.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final DatabaseHelper _databaseHelper;

  NoteBloc(this._databaseHelper) : super(NoteInitial()) {
    on<LoadEventsByDate>(_onLoadEventsByDate);
    on<AddEvent>(_onAddEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadEventsByDate(
      LoadEventsByDate event, Emitter<NoteState> emit) async {
    emit(NoteLoadInProgress());
    try {
      final notes = await _databaseHelper.getNotesByDate(event.date);
      emit(NoteLoadSuccess(notes));
    } catch (e) {
      print('Error loading notes: $e');
      emit(NoteLoadFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<NoteState> emit) async {
    emit(NoteLoadInProgress());
    try {
      await _databaseHelper.insertNote(event.note);
      final notes = await _databaseHelper.getNotesByDate(event.note.date);
      emit(NoteLoadSuccess(notes));
    } catch (e) {
      print('Error adding note: $e');
      emit(NoteLoadFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateEvent(UpdateEvent event, Emitter<NoteState> emit) async {
    emit(NoteLoadInProgress());
    try {
      await _databaseHelper.updateNote(event.note);
      final notes = await _databaseHelper.getNotesByDate(event.note.date);
      emit(NoteLoadSuccess(notes));
    } catch (e) {
      print('Error updating note: $e');
      emit(NoteLoadFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<NoteState> emit) async {
    emit(NoteLoadInProgress());
    try {
      await _databaseHelper.deleteNote(event.id);
      final notes = await _databaseHelper.getNotesByDate(event.date);
      emit(NoteLoadSuccess(notes));
    } catch (e) {
      print('Error deleting note: $e');
      emit(NoteLoadFailure(errorMessage: e.toString()));
    }
  }
}
