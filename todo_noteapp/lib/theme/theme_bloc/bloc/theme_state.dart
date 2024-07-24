part of 'theme_bloc.dart';

sealed class ThemeState {}

final class ThemeChangeState extends ThemeState {
  final ThemeData themeData;
   ThemeChangeState(this.themeData);
}
