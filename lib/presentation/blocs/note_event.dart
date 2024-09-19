import 'package:equatable/equatable.dart';
import 'package:notes_app/data/model/notes_model.dart';

abstract class NoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEventsByDate extends NoteEvent {
  final DateTime date;

  LoadEventsByDate(this.date);

  @override
  List<Object?> get props => [date];
}

class AddEvent extends NoteEvent {
  final Note note;

  AddEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class UpdateEvent extends NoteEvent {
  final Note note;

  UpdateEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteEvent extends NoteEvent {
  final int id;
  final DateTime date;

  DeleteEvent(this.id, this.date);

  @override
  List<Object?> get props => [id, date];
}
