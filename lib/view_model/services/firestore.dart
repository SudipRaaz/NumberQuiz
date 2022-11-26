import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/game_summary_model.dart';
import '../../model/user.dart';
import 'authentication.dart';
import 'firebase_abstract.dart';

class CloudStore extends FirebaseBase {
  // function to store user registration data to database
  @override
  Future registerUser(String? uid, String name, String email, int? age) async {
    final docUser = FirebaseFirestore.instance
        .collection('Users')
        .doc(Auth().currentUser?.uid);

    final user =
        User(uid: uid, name: name, email: email, age: age, totalScore: 0);

    await docUser.set(user.toJson());
  }

  // function to upload the game score to database
  @override
  uploadToDatabase(String date, String score, String gameMode) async {
    final doc = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth().currentUser!.uid)
        .collection("GameData")
        .doc();
    final gameData = GameSummary(date: date, score: score, gameMode: gameMode);
    final gameDataJson = gameData.toJson();
    await doc.set(gameDataJson, SetOptions(merge: true));
  }

  // update the total score of the player by adding current game score to total score
  @override
  updateTotalScore(int totalScored) async {
    final doc = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth().currentUser!.uid);
    final user = {'TotalScore': totalScored};
    await doc.update(user);
  }

  @override
  Future<User?> readUserData() async {
    final doc = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth().currentUser!.uid);
    final snapshot = await doc.get();
    if (snapshot.exists) {
      return User.fromJson(snapshot.data()!);
    }
    return null;
  }

  @override
  Future sendEmailVerfication() async {
    await Auth().currentUser!.sendEmailVerification();

    print("email verfication sent");
    Auth().signOut();
  }
}
