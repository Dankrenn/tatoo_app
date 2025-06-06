import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _themeBox = 'ThemeBox';
  static const String _themeKey = 'ThemeBox';

  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<void> setIsDaskMode(bool isDarkMode) async {
    var box = await Hive.openBox(_themeBox);
    await box.put(_themeKey, isDarkMode);
  }

  Future<bool> getIsDaskMode() async {
    var box = await Hive.openBox(_themeBox);
    return await box.get(_themeKey, defaultValue: false);
  }
}