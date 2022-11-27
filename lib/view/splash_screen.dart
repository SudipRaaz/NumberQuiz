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
  @override
  Widget build(BuildContext context) {
    // creating a stream for auth changes to listen
    return StreamBuilder(
      stream: Auth().authStateChange,
      builder: (context, snapshot) {
        // if snapshot from stream has data loading dashboard page
        if (snapshot.hasData) {
          return const Dashboard();
        } else {
          // if snapshot from stream has does not have any data loading login page
          return const LoginScreen();
        }
      },
    );
  }
}
