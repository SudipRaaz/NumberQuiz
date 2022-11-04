import 'package:flutter/material.dart';
import 'package:smile_quiz/utilities/message.dart';
import 'package:smile_quiz/view_model/services/auth.dart';

import '../utilities/route/routes_name.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromARGB(255, 245, 212, 94),
          child: Column(
            children: [
              Container(),
              Padding(
                padding: EdgeInsets.all(100.0),
                child: ElevatedButton(
                    onPressed: () {
                      Auth().signOut();
                    },
                    child: const Text("Help")),
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
