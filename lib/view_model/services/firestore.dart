import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../model/game_summary_model.dart';
import '../../model/user.dart';
import 'authentication.dart';
import 'firebase_abstract.dart';

class CloudStore extends FirebaseBase {
  // function to store user registration data to database
  @override
  Future registerUser(String? uid, String name, String email, int? age) async {
    // collection reference and doc id naming
    final docUser = FirebaseFirestore.instance
        .collection('Users')
        .doc(Auth().currentUser?.uid);
    // creating User class object
    final user =
        User(uid: uid, name: name, email: email, age: age, totalScore: 0);

    // wating for doc set josn object on firebase
    await docUser.set(user.toJson());
  }

  // function to upload the game score to database
  @override
  uploadToDatabase(String date, String score, String gameMode) async {
    // firebase collection reference
    final doc = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth().currentUser!.uid)
        .collection("GameData")
        .doc();
    // creating GameSummary class object
    final gameData = GameSummary(date: date, score: score, gameMode: gameMode);
    // modeling object to json format
    final gameDataJson = gameData.toJson();
    // setting the json file on firebase and setting merge = true to update if value already exists
    await doc.set(gameDataJson, SetOptions(merge: true));
  }

  // update the total score of the player by adding current game score to total score
  @override
  updateTotalScore(int totalScored) async {
    // collection reference
    final doc = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth().currentUser!.uid);
    // creating user json format data of totalscore
    final user = {'TotalScore': totalScored};
    // updating the total score
    await doc.update(user);
  }

  @override
  Future<User?> readUserData() async {
    // collection reference to readuser from
    final doc = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth().currentUser!.uid);
    // get the data from doc
    final snapshot = await doc.get();
    if (snapshot.exists) {
      // if odc exists
      return User.fromJson(snapshot.data()!);
    }
    // return null if doc does not exits
    return null;
  }

  @override
  Future sendEmailVerfication() async {
    // sending email verfication
    await Auth().currentUser!.sendEmailVerification();

    debugPrint("email verfication sent");
    // log user out
    Auth().signOut();
  }
}
