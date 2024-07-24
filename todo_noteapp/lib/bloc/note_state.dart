part of 'note_bloc.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

class LoadingState extends NoteState{}

class SuccessState extends NoteState{
  final List<NoteModel> notes;
  SuccessState(this.notes);
}

class ErrorState extends NoteState{
  final String error;
  ErrorState(this.error);
}
