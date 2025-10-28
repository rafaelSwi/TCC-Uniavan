// lib/language_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selectedLanguage';

  Future<String?> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  Future<void> setSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}
