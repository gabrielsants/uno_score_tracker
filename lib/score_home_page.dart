import 'package:flutter/material.dart';

import 'main.dart';
import 'player_model.dart';
import 'score_view_model.dart';

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
        title: const Text('UNO Score Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Scores',
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'UNO Score Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
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
                    decoration: const InputDecoration(
                      labelText: 'Add Player',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.person_add),
                    ),
                    onSubmitted: (value) => setState(() {
                      scoreVM.addPlayer(value);
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => setState(() {
                    scoreVM.addPlayer(scoreVM.playerNameController.text);
                  }),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: scoreVM.players.isEmpty
                ? const Center(
                    child: Text(
                      'No players added yet.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
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
                          scoreVM.updateScore(player, delta);
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
                  'Score: ${player.score}',
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
                  label: const Text('Remove',
                      style: TextStyle(color: Colors.white)),
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
        title: const Text('Sobre'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UNO Score Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Este aplicativo ajuda você a rastrear pontuações de partidas de UNO de forma simples e eficiente. '
              'Você pode adicionar até 10 jogadores, ajustar as pontuações e reiniciar as partidas com facilidade.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Desenvolvido com Flutter por Gabriel Santos.',
              style: TextStyle(fontSize: 16),
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
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Zerar pontos ao remover jogador'),
              value: AppSettings.resetPointsOnRemove,
              onChanged: (bool value) {
                setState(() {
                  AppSettings.resetPointsOnRemove = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Zerar pontos ao adicionar novo jogador'),
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
