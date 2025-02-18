import 'package:flutter/material.dart';

import 'score_home_page.dart';

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
      title: 'UNO Score Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ScoreHomePage(),
    );
  }
}

