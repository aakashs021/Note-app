import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_noteapp/addpage.dart';
import 'package:todo_noteapp/bloc/note_bloc.dart';
import 'package:todo_noteapp/note_model.dart';

class DetailScreen extends StatelessWidget {
  final NoteModel noteModel;
  const DetailScreen({super.key, required this.noteModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              NoteModel note=NoteModel(noteModel.id,noteModel.title,noteModel.content);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Addpage(noteModel: note,add: false,),
                ),
              );
            },
            icon: const Icon(Icons.edit_note_sharp),
          ),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView(
                children: [
                  Text(
                    noteModel.title,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 40),
                  ),
                  Text(
                    noteModel.content,
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ));
        },
      ),
    );
  }
}
