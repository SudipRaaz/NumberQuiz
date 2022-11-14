import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/user.dart';
import 'auth.dart';

class CloudStore {
  static Future registerUser(
      String? uid, String name, String email, int age) async {
    final docUser = FirebaseFirestore.instance
        .collection('Users')
        .doc('${Auth().currentUser?.uid}');

    final user = User(uid: uid, name: name, email: email, age: age);

    await docUser.set(user.toJson());
  }
}
