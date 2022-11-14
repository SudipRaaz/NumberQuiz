class User {
  String? uid;
  String name;
  int age;
  String email;

  User({this.uid, required this.name, required this.email, required this.age});

  Map<String, dynamic> toJson() =>
      {'uid': uid, 'name': name, 'email': email, 'age': age};
}
