import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/view/dashboard.dart';
import 'package:smile_quiz/view/login_screen.dart';
import 'package:smile_quiz/view_model/services/authentication.dart';

// ignore: camel_case_types
class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

// ignore: camel_case_types
class _Splash_ScreenState extends State<Splash_Screen> {
  // ignore: prefer_typing_uninitialized_variables
  var token;

  // ignore: prefer_typing_uninitialized_variables
  var data;

  Timer? time;

  @override
  void initState() {
    super.initState();
    log(Auth().currentUser.toString(), name: "User Authentication : ");
  }

  void resetSession(context) async {
    time = Timer.periodic(const Duration(seconds: 20), (ti) {
      Auth().signOut();
      cancelTImer();
    });
  }

  cancelTImer() {
    time?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Dashboard();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
