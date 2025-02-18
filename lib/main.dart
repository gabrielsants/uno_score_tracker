import 'package:flutter/material.dart';

import 'score_home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const UnoScoreApp());
}

// Classe global para gerenciar as configuracoes do aplicativo
// No futuro poderao ter novas configuracoes nessa tela
class AppSettings {
  static bool resetPointsOnRemove = false;
  static bool resetPointsOnNewPlayer = false;
}

class UnoScoreApp extends StatelessWidget {
  const UnoScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'salve', //AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('pt'), // Portuguese
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ScoreHomePage(),
    );
  }
}

