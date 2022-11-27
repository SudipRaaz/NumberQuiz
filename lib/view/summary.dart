import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/constants/textStyle.dart';
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
  late final String _gameModeString =
      widget.gameMode ? "Hard" : "Easy"; // game mode from bool to string
  late final int _scored = widget.score; // score secured by player
  late final int _bonusScore =
      widget.gameMode ? 2 : 0; // bonus score for hard mode player

  // widget spacing constant value
  final double _spacing = 10;

  @override
  void initState() {
    FirebaseBase obj = CloudStore();

    obj.uploadToDatabase(
        DateTime.now().toString(),
        widget.gameMode ? {_scored + 2}.toString() : {_scored}.toString(),
        _gameModeString);

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
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: FutureBuilder(
      future: readUserData(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          // if snapshot has data
          final user = snapshot.data; // get the snapshot data of user
          // creating the obj of base abstract class
          FirebaseBase obj = CloudStore();
          // updating the total score to remote database adding current score and bonus points to the existing player total score
          obj.updateTotalScore(user!.totalScore! + _scored + _bonusScore);
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // Below is the code for Linear Gradient.
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple,
                  Color.fromARGB(255, 33, 82, 243),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.13,
                ),
                // stacking widgets
                Stack(children: [
                  CircleAvatar(
                    maxRadius: 130,
                    backgroundColor: Colors.amber[400],
                  ),
                  // positioned widget
                  const Positioned(
                    top: 10,
                    left: 10,
                    // decorating circle avatar
                    child: CircleAvatar(
                      maxRadius: 120,
                      backgroundColor: Color.fromARGB(34, 102, 101, 97),
                      backgroundImage: AssetImage("assets/pictures/bronze.jpg"),
                    ),
                  ),
                ]),
                // spacing
                SizedBox(
                  height: height * 0.03,
                ),
                Center(
                    child: Text(
                  "Quiz Summary",
                  style: AppTextStyle.heading_h1,
                )),
                SizedBox(
                  height: height * 0.06,
                ),
                Container(
                  // color: Colors.amber,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(15)),
                  height: height * 0.18,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: _spacing,
                        ),
                        // displaying scored secured
                        Row(
                          children: [
                            Text(
                              "Score : $_scored ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              // decorating container
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/pictures/star.png"))),
                              ),
                            )
                          ],
                        ),
                        // constant spacing
                        SizedBox(
                          height: _spacing,
                        ),
                        // bonus score secured
                        Row(
                          children: [
                            const Text(
                              "Bonus : ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            widget.gameMode
                                ? Text(
                                    _bonusScore.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                : Text(
                                    _bonusScore.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: _spacing,
                        ),
                        // displaying gameMode
                        Text(
                          "Game Mode : $_gameModeString",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )
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
