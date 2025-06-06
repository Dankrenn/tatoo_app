import 'package:flutter/material.dart';

import '../services/hive_service.dart';

class ThemeModel extends ChangeNotifier{
  HiveService hiveService = HiveService();
  late bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeModel() {
    updateTheme();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await hiveService.getIsDaskMode();
    notifyListeners();
  }

  Future<void> updateTheme() async {
    _isDarkMode = !_isDarkMode;
    await hiveService.setIsDaskMode(_isDarkMode);
    notifyListeners();
  }

  ThemeData get theme => _isDarkMode ? ThemeData.dark() : ThemeData.light();

}