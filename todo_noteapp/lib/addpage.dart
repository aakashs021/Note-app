import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_noteapp/bloc/note_bloc.dart';
import 'package:todo_noteapp/note_model.dart';

class Addpage extends StatefulWidget {
  const Addpage({super.key, this.add = true, this.noteModel});
  final NoteModel? noteModel;
  final bool add;

  @override
  State<Addpage> createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {
  TextEditingController titlecontroll = TextEditingController();
  bool add = true;
  TextEditingController contentcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (!widget.add) {
      add = widget.add;
      titlecontroll.text = widget.noteModel!.title;
      contentcontroller.text = widget.noteModel!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(add ? 'Add page' : 'Edit page'),
        actions: [
          BlocConsumer<NoteBloc, NoteState>(
            listener: (context, state) {
              if (state is ErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red.shade300,
                    duration: const Duration(seconds: 1),
                    content: Text(state.error),
                  ),
                );
              } else if (state is SuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.green.shade300,
                      duration: const Duration(seconds: 1),
                      content: Text(add ? "Note Added" : 'Note editted')),
                );
                add
                    ? Navigator.pop(context)
                    : Navigator.of(context).popUntil((route) => route.isFirst);
                
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                  onPressed: () {
                    NoteModel noteModel = NoteModel(
                        add
                            ? DateTime.now().millisecondsSinceEpoch
                            : widget.noteModel!.id,
                        titlecontroll.text,
                        contentcontroller.text);
                    add
                        ? context.read<NoteBloc>().add(NoteAddEvent(noteModel))
                        : context
                            .read<NoteBloc>()
                            .add(NoteUpdateEvent(notes: noteModel));
                  },
                  child: const Text('Save'));
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            TextFormField(
              controller: titlecontroll,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: contentcontroller,
              maxLines: 100,
              minLines: 1,
              decoration: const InputDecoration(
                  hintText: 'Note', border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }
}
