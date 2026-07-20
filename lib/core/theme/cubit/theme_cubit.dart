import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  bool get isDarkMode => state == ThemeMode.dark;

  void toggleTheme() {
    emit(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}
