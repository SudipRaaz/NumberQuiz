import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/appcolors.dart';
import 'package:smile_quiz/resources/constants.dart';
import 'package:smile_quiz/resources/textStyle.dart';
import 'package:smile_quiz/utilities/message.dart';
import 'package:smile_quiz/view/quizPage.dart';
import 'package:smile_quiz/view/summary.dart';
import 'package:smile_quiz/view_model/services/authentication.dart';

import '../resources/components/button.dart';
import '../utilities/route/routes_name.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double buttonGap = 8;

  @override
  void initState() {
    var token = Auth().currentUser?.uid;
    log(Auth().currentUser.toString(), name: "User Authentication : ");
    super.initState();
  }

  var _quizMode = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.app_background,
          child: SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Quiz \nMode   ",
                          style: AppTextStyle.normal,
                        ),
                        Text(
                          "Easy",
                          style: AppTextStyle.normal,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Transform.scale(
                            scale: 1.3,
                            child: Switch(
                              value: _quizMode,
                              onChanged: (value) {
                                setState(() {
                                  _quizMode = !_quizMode;
                                });
                              },
                              activeColor: Color.fromARGB(255, 255, 62, 48),
                              activeTrackColor:
                                  Color.fromARGB(255, 255, 197, 203),
                              inactiveTrackColor:
                                  Color.fromARGB(255, 172, 255, 203),
                              inactiveThumbColor:
                                  Color.fromARGB(255, 54, 255, 60),
                            ),
                          ),
                        ),
                        Text(
                          "Hard",
                          style: AppTextStyle.normal,
                        ),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 80, 97, 246),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: () {
                          Auth().signOut();
                        },
                        child: const Text("Sign Out")),
                  ],
                ),
              ),
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
                          // Navigator.pushNamed(context, RoutesName.quizPage,
                          //     arguments: _quizMode
                          //         ? AppConstant.hardModeTimer
                          //         : AppConstant.easyModeTimer);
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
                height: buttonGap,
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
                height: buttonGap,
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
                        onPressed: () {},
                        child: const Text(
                          "Help",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: buttonGap,
              ),
            ]),
          )),
    );
  }
}
