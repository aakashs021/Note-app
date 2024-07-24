import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_noteapp/note_model.dart';

part 'note_event.dart';
part 'note_state.dart';

const baseUrl = "https://gsdpcr3h-3000.inc1.devtunnels.ms/";

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitial()) {
    on<NoteAddEvent>(onaddevent);
    on<GetAllNotes>(getallnotes);
    on<NoteDeleteEvent>(ondeleteevent);
    on<NoteUpdateEvent>(onupdateevent);
  }

  getallnotes(GetAllNotes event, Emitter<NoteState> emit) async {
    emit(LoadingState());
    try {
      final res = await http.get(Uri.parse('${baseUrl}getAllNotes'));
      List notelist = jsonDecode(res.body);
      List<NoteModel> notemodel = [];
      for (Map val in notelist) {
        NoteModel newnote = NoteModel(val['id'], val['title'], val['content']);
        notemodel.add(newnote);
      }
      if (res.statusCode == 200) {
        emit(SuccessState(notemodel));
      } else {
        emit(ErrorState('Server is not responding'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  onaddevent(NoteAddEvent event, Emitter<NoteState> emit) async {
    if (event.notes.title.isEmpty) {
      return emit(ErrorState('There is no title'));
    }
    Map<String, dynamic> json = {
      'id': event.notes.id,
      'title': event.notes.title,
      'content': event.notes.content
    };
    emit(LoadingState());
    try {
      final res = await http.post(Uri.parse("${baseUrl}addNode"),
          body: jsonEncode(json),
          headers: {"Content-Type": "application/json"});

      if (res.statusCode == 200) {
        List notelist = await jsonDecode(res.body);
        List<NoteModel> notemodel = [];
        for (Map val in notelist) {
          NoteModel newnote =
              NoteModel(val['id'], val['title'], val['content']);
          notemodel.add(newnote);
        }
        emit(SuccessState(notemodel));
      } else {
        emit(ErrorState('Server not responding '));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  ondeleteevent(NoteDeleteEvent event, Emitter<NoteState> emit) async {
    try {
      final res = await http.post(
        Uri.parse('${baseUrl}deleteNote/${event.notes.id}'),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        final allNotesResponse =
            await http.get(Uri.parse('${baseUrl}getAllNotes'));
        List notelist = jsonDecode(allNotesResponse.body);
        List<NoteModel> notemodel = [];
        for (Map val in notelist) {
          NoteModel newnote =
              NoteModel(val['id'], val['title'], val['content']);
          notemodel.add(newnote);
        }
        emit(SuccessState(notemodel));
      } else {
        emit(ErrorState('Server not responding'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
  onupdateevent(NoteUpdateEvent event,Emitter<NoteState> emit)async{
     Map<String, dynamic> jsonData = {
      'id': event.notes.id,
      'title': event.notes.title,
      'content': event.notes.content,};
    try{


    final res=await http.post(Uri.parse('${baseUrl}updateNote/${event.notes.id}'),
    body: jsonEncode(jsonData),
    headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
        final allNotesResponse =
            await http.get(Uri.parse('${baseUrl}getAllNotes'));
        List notelist = jsonDecode(allNotesResponse.body);
        List<NoteModel> notemodel = [];
        for (Map val in notelist) {
          NoteModel newnote =
              NoteModel(val['id'], val['title'], val['content']);
          notemodel.add(newnote);
        }
        emit(SuccessState(notemodel));
      } else {
        emit(ErrorState('Server not responding'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
