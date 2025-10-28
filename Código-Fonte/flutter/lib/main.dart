import 'package:flutter/material.dart';
import 'package:MegaObra/screens/auth/login.dart';
import 'package:window_size/window_size.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Definindo o título e o tamanho da janela
  setWindowTitle('MegaObra');
  setWindowMinSize(const Size(900, 800));
  setWindowMaxSize(const Size(7680, 4320));

  // Recuperando o idioma selecionado do SharedPreferences ou usando o padrão (en)
  final languageService = LanguageService();
  String languageCode = await languageService.getSelectedLanguage() ?? 'en';

  runApp(MyApp(languageCode));
}

class MyApp extends StatelessWidget {
  final String languageCode;

  MyApp(this.languageCode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MegaObra',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: LoginPage(),
      locale: Locale(languageCode),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('pt'),
        Locale('es'),
      ],
    );
  }
}
