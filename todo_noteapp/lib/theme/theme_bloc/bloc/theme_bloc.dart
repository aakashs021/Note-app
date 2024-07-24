import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_noteapp/colors.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeChangeState(lightMode)) {
    on<ThemeChangeEvent>((event, emit) {
      ((state as ThemeChangeState).themeData == darkMode)?emit(ThemeChangeState(lightMode)):emit(ThemeChangeState(darkMode));
    });
  }
}

