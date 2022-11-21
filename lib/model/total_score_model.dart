class TotalScored {
  int totalScore;

  TotalScored({required this.totalScore});

  Map<String, dynamic> toJson() => {'TotalScore': totalScore};

  static TotalScored fromJson(Map<String, dynamic> json) =>
      TotalScored(totalScore: json['TotalScore']);
}
