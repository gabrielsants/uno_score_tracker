import 'package:flutter/material.dart';

import 'main.dart';
import 'player_model.dart';
import 'score_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoreHomePage extends StatefulWidget {
  const ScoreHomePage({super.key});

  @override
  State<ScoreHomePage> createState() => _ScoreHomePageState();
}

class _ScoreHomePageState extends State<ScoreHomePage> {
  // Instanciação da classe para acessar dentro da class ScoreHomePage
  final ScoreViewModel scoreVM = ScoreViewModel();

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.resetScore,
            onPressed: () {
              setState(() {
                scoreVM.resetScores;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                AppLocalizations.of(context)!.appTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(AppLocalizations.of(context)!.home),
              onTap: () {
                Navigator.pop(context); // Fecha o menu
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(AppLocalizations.of(context)!.about),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
                leading: const Icon(Icons.settings),
                title: Text(AppLocalizations.of(context)!.settings),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                })
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: scoreVM.playerNameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.addPlayer,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.person_add),
                    ),
                    onSubmitted: (value) => setState(() {
                      scoreVM.addPlayer(context, value);
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => setState(() {
                    scoreVM.addPlayer(context, scoreVM.playerNameController.text);
                  }),
                  child: Text(AppLocalizations.of(context)!.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: scoreVM.players.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noPlayers,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (screenWidth ~/ 150).clamp(2, 4),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: scoreVM.players.length,
                    itemBuilder: (context, index) {
                      final player = scoreVM.players[index];
                      return PlayerCard(
                        player: player,
                        onScoreChange: (delta) => setState(() {
                          scoreVM.updateScore(context, player, delta);
                          if (scoreVM.snackbarKillStreakText != null) {
                            //? Linter do Dart nao é mt inteligente, entao se eu nao colocar o "!", ele
                            //? fica pensando que pode ser nulo MESMO DENTRO DA PORRA DO IF
                            showSnackBar(scoreVM.snackbarKillStreakText!);
                            scoreVM.snackbarKillStreakText = null;
                          } else if (scoreVM.snackbarNewGameLeaderText !=
                              null) {
                            showSnackBar(scoreVM.snackbarNewGameLeaderText!);
                            scoreVM.snackbarNewGameLeaderText = null;
                          }
                        }),
                        onRemove: () => setState(() {
                          scoreVM.removePlayer(player);
                        }),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final Player player;
  final Function(int) onScoreChange;
  final VoidCallback onRemove;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onScoreChange,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              player.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                    '${AppLocalizations.of(context)!.score}: ${player.score}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => onScoreChange(-1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.remove, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () => onScoreChange(1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: onRemove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: Text(AppLocalizations.of(context)!.remove,
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  /// A key identifica o widget dentro da arvore de Widgets e ela notifica
  /// a engine do Flutter se houve alguma modificação no componente
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.aboutSection +
              AppLocalizations.of(context)!.aboutSectionRules,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.madeBy,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.resetScoreOnRemove),
              value: AppSettings.resetPointsOnRemove,
              onChanged: (bool value) {
                setState(() {
                  AppSettings.resetPointsOnRemove = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.resetScoreOnAdd),
              value: AppSettings.resetPointsOnNewPlayer,
              onChanged: (bool value) {
                setState(() {
                  AppSettings.resetPointsOnNewPlayer = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
