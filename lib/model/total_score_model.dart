class TotalScored {
  int totalScore;

  TotalScored({required this.totalScore});

  // convert tojson
  Map<String, dynamic> toJson() => {'TotalScore': totalScore};

  // convert fromjsons
  static TotalScored fromJson(Map<String, dynamic> json) =>
      TotalScored(totalScore: json['TotalScore']);
}
