import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/textStyle.dart';
import 'package:smile_quiz/utilities/message.dart';
import 'package:smile_quiz/view_model/services/auth.dart';

import '../utilities/route/routes_name.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _quizMode = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 255, 224, 67),
          child: Column(
            children: [
              SizedBox(
                height: height * .08,
              ),
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.login);
                  },
                  child: const Text("Login")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.quizPage);
                  },
                  child: const Text("Play game")),
              ElevatedButton(
                  onPressed: () {
                    Message.flushBarErrorMessage(
                        context, "Leadership board not available");
                  },
                  child: const Text("Leadership Board")),
              ElevatedButton(onPressed: () {}, child: const Text("Help")),
            ],
          )),
    );
  }
}
