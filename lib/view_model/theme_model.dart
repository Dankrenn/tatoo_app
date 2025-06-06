import 'package:flutter/material.dart';

import '../services/hive_service.dart';

class ThemeModel extends ChangeNotifier {
  final HiveService hiveService = HiveService();
  late bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeModel() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await hiveService.getIsDaskMode() ?? false;
    notifyListeners();
  }

  Future<void> updateTheme() async {
    _isDarkMode = !_isDarkMode;
    await hiveService.setIsDaskMode(_isDarkMode);
    notifyListeners();
  }

  ThemeData get theme => _isDarkMode
      ? ThemeData.dark().copyWith(
    // Кастомизация темной темы
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black87,
    ),
  )
      : ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
    ),
  );
}