import 'package:flutter/material.dart';

import 'main.dart';
import 'player_model.dart';

class ScoreViewModel {
  final List<Player> players = [];
  final TextEditingController playerNameController = TextEditingController();

  String? snackbarKillStreakText;
  String? snackbarNewGameLeaderText;

  Player? lastPlayer;
  Player? lastLeader;

  void addPlayer(String name) {
    if (name.isNotEmpty && players.length < 10) {
      players.add(
        Player(
          name: name,
          backgroundImage:
              'assets/card_background_${players.length % 4 + 1}.png',
        ),
      );
      verifyUserParametersOnNewPlayer();
      playerNameController.clear();
    }
  }

  void verifyUserParametersOnNewPlayer() {
    if (AppSettings.resetPointsOnNewPlayer) {
      for (var player in players) {
        player.score = 0;
        player.streak = 0;
      }
      lastLeader = null;
      lastPlayer = null;
    }
  }

  void updateScore(Player player, int delta) {
    // Atualiza a pontuação do jogador.
    player.score += delta;

    // Ordena os jogadores pela pontuação em ordem decrescente.
    players.sort((a, b) => b.score.compareTo(a.score));

    // Gerencia a sequência de pontos.
    if (delta > 0) {
      if (lastPlayer == player) {
        // Incrementa a sequência se o mesmo jogador continua pontuando.
        player.streak++;
        if (player.streak > 1) {
          //? É uma forma alternativa para salvar o texto e mostrar na view...
          snackbarKillStreakText =
              '${player.name} está com tudo, ${player.streak} pontos seguidos!';
        }
      } else {
        // Se outro jogador pontuar, a sequência do anterior é zerada.
        for (final Player p in players) {
          if (p != player) {
            p.streak = 0;
          }
        }
        // Atualiza o jogador atual e inicia a sequência para ele.
        player.streak = 1;
        lastPlayer = player;
      }
    }

    // Verifica se há uma nova liderança.
    if (players.isNotEmpty && players.first != lastLeader) {
      lastLeader = players.first;
      //? É uma forma alternativa para salvar o texto e mostrar na view...
      snackbarNewGameLeaderText = '${players.first.name} assumiu a liderança!';
    }
  }

  void resetScores() {
    for (var player in players) {
      player.score = 0;
      player.streak = 0;
    }
    lastLeader = null;
    lastPlayer = null;
  }

  void removePlayer(Player player) {
    players.remove(player);
    verifyUserParameters();
  }

  void verifyUserParameters() {
    if (AppSettings.resetPointsOnRemove) {
      for (var player in players) {
        player.score = 0;
        player.streak = 0;
      }
      lastLeader = null;
      lastPlayer = null;
    } else if (players.isNotEmpty && players.first == lastLeader) {
      lastLeader = null;
      lastPlayer = null;
    }
  }
}
