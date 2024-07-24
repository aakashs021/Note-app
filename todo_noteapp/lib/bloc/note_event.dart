part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

class NoteAddEvent extends NoteEvent {
  final NoteModel notes;
  NoteAddEvent(this.notes);
}

class GetAllNotes extends NoteEvent{}

class NoteDeleteEvent extends NoteEvent{
  final NoteModel notes;
  NoteDeleteEvent(this.notes);
}

class NoteUpdateEvent extends NoteEvent {
  final NoteModel notes;
  NoteUpdateEvent({
    required this.notes,
  });
  
}

