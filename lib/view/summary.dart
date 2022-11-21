import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/model/game_summary_model.dart';
import 'package:smile_quiz/view_model/services/authentication.dart';

import '../model/user.dart';
import '../view_model/services/firebase_abstract.dart';
import '../view_model/services/firestore.dart';

// ignore: must_be_immutable
class QuizSummary extends StatefulWidget {
  QuizSummary({required this.score, required this.gameMode, super.key});
  int score;
  bool gameMode;

  @override
  State<QuizSummary> createState() => _QuizSummaryState();
}

class _QuizSummaryState extends State<QuizSummary> {
  late final String _gameModeString = widget.gameMode ? "Hard" : "Easy";
  late int _totalScore;

  @override
  void initState() {
    FirebaseBase obj = CloudStore();

    obj.uploadToDatabase(
        DateTime.now().toString(), widget.score.toString(), _gameModeString);

    super.initState();
  }

  // Function to retrive the user's total score form database
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
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: FutureBuilder(
      future: readUserData(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          // if snapshot has data
          final user = snapshot.data; // get the snapshot data of user

          /* retrive the current total score from user!.totalscore! 
          and add the current score to existing score  */
          FirebaseBase obj = CloudStore();
          obj.updateTotalScore(user!.totalScore! + widget.score);
          return SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: height / 16,
                ),
                Stack(children: [
                  CircleAvatar(
                    maxRadius: 130,
                    backgroundColor: Colors.amber[400],
                  ),
                  const Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      maxRadius: 120,
                      backgroundColor: Color.fromARGB(34, 102, 101, 97),
                      backgroundImage: AssetImage("assets/pictures/bronze.jpg"),
                    ),
                  ),
                ]),
                SizedBox(
                  height: height / 15,
                ),
                const Center(child: Text("Quiz Summary")),
                Text("score : ${widget.score}"),
                Text("date : " + DateTime.now().toString()),
                Text("game mode : " + _gameModeString.toString()),
                Text({user!.totalScore! + widget.score}.toString()),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    ));
  }
}
