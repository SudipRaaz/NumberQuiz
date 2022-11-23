import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/appcolors.dart';
import 'package:smile_quiz/resources/constants.dart';
import 'package:smile_quiz/resources/textStyle.dart';
import 'package:smile_quiz/view/quizPage.dart';
import 'package:smile_quiz/view_model/services/authentication.dart';

import '../model/user.dart';
import '../utilities/route/routes_name.dart';
import '../view_model/services/firebase_abstract.dart';
import '../view_model/services/firestore.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final double _buttonGap = 8; // widget spacing gap
  var _quizMode = false; // quiz mode selection (hard or easy)
  final bool _isVerified = Auth().currentUser!.emailVerified;

  List _scoreData = []; // is user's email verified or not

  @override
  void initState() {
    log(Auth().currentUser.toString(), name: "User Authentication : ");
    super.initState();
  }

  Future sendEmailVerfication() async {
    await Auth().currentUser!.sendEmailVerification();

    print("email verfication sent");
    Auth().signOut();
  }

  Stream _userStream = FirebaseFirestore.instance
      .collection("Users")
      .doc(Auth()!.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    FirebaseBase obj = CloudStore();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBar_theme,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.app_background,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  Auth().signOut();
                },
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.black),
                )),
          ),
        ],
      ),
      drawer: StreamBuilder(
          stream: _userStream,
          builder: (context, snapshot) {
            _scoreData = [];
            if (snapshot.hasData) {
              var data = snapshot!.data;
              _scoreData.add(data);

              log(_scoreData.toString(), name: "score doc snapshot");
              log(data['TotalScore'].toString(), name: "score doc snapshot");
              // log(_scoreData.toString(), name: "score doc snapshot");

              // get the snapshot data of user
              return Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: Column(
                    // Important: Remove any padding from the ListView.
                    children: [
                      Container(
                          height: height * 0.38,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromARGB(255, 21, 43, 247),
                                Color.fromARGB(255, 87, 104, 255),
                                Color.fromARGB(255, 147, 157, 251),
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 255, 255, 255),
                              ])),
                          child: Center(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: NetworkImage(
                                          Auth().currentUser!.photoURL ??
                                              "https://th.bing.com/th/id/OIP.7jKcNNIq8rQLPZqRym9qvwHaIN?pid=ImgDet&rs=1",
                                        ),
                                      ),
                                      _isVerified
                                          ? const Positioned(
                                              right: 0,
                                              child: CircleAvatar(
                                                radius: 12,
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.verified,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                    ),
                                    child: Text(
                                      "${data['name']}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                  ),
                                ]),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  " Quiz \nMode      ",
                                  style: AppTextStyle.normal,
                                ),
                                Text(
                                  "Easy",
                                  style: AppTextStyle.normal,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Transform.scale(
                                    scale: 1.3,
                                    child: Switch(
                                      value: _quizMode,
                                      onChanged: (value) {
                                        setState(() {
                                          _quizMode = !_quizMode;
                                        });
                                      },
                                      activeColor: const Color.fromARGB(
                                          255, 255, 62, 48),
                                      activeTrackColor: const Color.fromARGB(
                                          255, 255, 197, 203),
                                      inactiveTrackColor: const Color.fromARGB(
                                          255, 172, 255, 203),
                                      inactiveThumbColor: const Color.fromARGB(
                                          255, 54, 255, 60),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Hard",
                                  style: AppTextStyle.normal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Text(
                              'Total Score:    ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/pictures/star.png'))),
                            ),
                            Text(
                              '  ${data['TotalScore']}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email Verification :',
                                  style: AppTextStyle.normal,
                                ),
                                !_isVerified
                                    ? Center(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.app_background,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50))),
                                            onPressed: () {
                                              sendEmailVerfication();
                                            },
                                            child: const Text(
                                              "Send Verfication  Email",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      )
                                    : Row(
                                        children: const [
                                          Text(
                                            "Verified",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            Text("Last Signed In"),
                            Text(Auth()
                                .currentUser!
                                .metadata
                                .lastSignInTime
                                .toString()),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ]),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.app_background,
          child: SafeArea(
            child: Column(children: [
              const Spacer(
                flex: 1,
              ),

              // play game button created and function assigned
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.0,
                            color: const Color.fromARGB(255, 250, 168, 168),
                            style: BorderStyle.solid,
                          ),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 61, 41, 215),
                                Color.fromARGB(255, 83, 119, 248),
                                Color.fromARGB(255, 176, 239, 255)
                              ],
                              end: Alignment.topCenter,
                              begin: Alignment.bottomCenter)),
                    )),

                    // button text styling
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(13)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return QuizPage(
                              timeAvailable: _quizMode
                                  ? AppConstant.hardModeTimer
                                  : AppConstant.easyModeTimer,
                              gameMode: _quizMode,
                            );
                          }));
                        },
                        child: const Text(
                          "Play Game",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: _buttonGap,
              ),

              // leadership board button created and function assigned
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.0,
                            color: const Color.fromARGB(255, 250, 168, 168),
                            style: BorderStyle.solid,
                          ),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 61, 41, 215),
                                Color.fromARGB(255, 83, 119, 248),
                                Color.fromARGB(255, 176, 239, 255)
                              ],
                              end: Alignment.topCenter,
                              begin: Alignment.bottomCenter)),
                    )),
                    // button text styling
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(13)),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutesName.leadership_board);
                        },
                        child: const Text(
                          "LearderShip Board",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: _buttonGap,
              ),
              // text help button and function assigned
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.0,
                            color: const Color.fromARGB(255, 250, 168, 168),
                            style: BorderStyle.solid,
                          ),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 61, 41, 215),
                                Color.fromARGB(255, 83, 119, 248),
                                Color.fromARGB(255, 176, 239, 255)
                              ],
                              end: Alignment.topCenter,
                              begin: Alignment.bottomCenter)),
                    )),
                    // text button styling
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(13)),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.help_Screen);
                        },
                        child: const Text(
                          "Help",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: _buttonGap,
              ),
            ]),
          )),
    );
  }
}
