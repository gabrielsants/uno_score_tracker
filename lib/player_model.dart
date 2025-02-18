class Player {
  final String name;
  int score;
  int streak; // Sequência de pontos.
  final String backgroundImage;

  Player({
    required this.name,
    this.score = 0,
    this.streak = 0,
    required this.backgroundImage,
  });
}
