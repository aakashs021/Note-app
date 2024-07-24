import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_noteapp/addpage.dart';
import 'package:todo_noteapp/bloc/note_bloc.dart';
import 'package:todo_noteapp/colors.dart';
import 'package:todo_noteapp/detail.dart';
import 'package:todo_noteapp/note_model.dart';
import 'package:todo_noteapp/theme/theme_bloc/bloc/theme_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NoteBloc>().add(GetAllNotes());
    ThemeBloc themebloc = context.read<ThemeBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(onPressed: () {
            themebloc.add(ThemeChangeEvent());
          }, icon: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              if ((state as ThemeChangeState).themeData == lightMode) {
                return const Icon(Icons.light_mode_outlined);
              } else {
                return const Icon(Icons.dark_mode_outlined);
              }
            },
          ))
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(child: Lottie.asset("assets/loading.json"));
          } else if (state is SuccessState) {
            return state.notes.isEmpty
                ? Center(
                    child:
                        Lottie.asset('assets/Animation - 1715440391123.json'),
                  )
                : gridnote(state.notes);
          }
          return Center(
            child: Lottie.asset("assets/Animation - 1715440862032.json"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Addpage(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget gridnote(List<NoteModel> notelist) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: notelist.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure you want to delete?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('NO')),
                    TextButton(
                        onPressed: () {
                          context
                              .read<NoteBloc>()
                              .add(NoteDeleteEvent(notelist[index]));
                          Navigator.pop(context);
                        },
                        child: const Text('Yes'))
                  ],
                );
              },
            );
          },
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailScreen(
                noteModel: notelist[index],
              ),
            ));
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    notelist[index].title),
                Text(
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 5,
                    notelist[index].content)
              ],
            ),
          ),
        );
      },
    );
  }
}
