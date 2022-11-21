class GameSummary {
  String date;
  String score;
  String gameMode;

  GameSummary(
      {required this.date, required this.score, required this.gameMode});

  Map<String, dynamic> toJson() =>
      {'date': date, 'score': score, 'mode': gameMode};
}
