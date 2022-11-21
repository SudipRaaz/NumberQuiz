class User {
  String? uid;
  String name;
  int age;
  String email;
  int? totalScore;

  User(
      {this.uid,
      required this.name,
      required this.email,
      required this.age,
      this.totalScore});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'age': age,
        'TotalScore': totalScore
      };

  static User fromJson(Map<String, dynamic> json) => User(
      name: json['name'],
      email: json['email'],
      age: json['age'],
      totalScore: json['TotalScore'],
      uid: json['uid']);
}
