import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';
import 'package:smile_quiz/view/dashboard.dart';
import 'package:smile_quiz/view/login_screen.dart';
import 'package:smile_quiz/view_model/services/auth.dart';

class Splash_Screen extends StatefulWidget {
  Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  var token;

  var data;

  Timer? time;

  @override
  void initState() {
    var token = Auth().currentUser?.uid;
    Auth().setLocalUserToken(token);
    Auth().getUserToken();
    log(token.toString(), name: "sending token value");
    getUsertoken();
  }

  getUsertoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    this.token = await pref.getString("token");
    log(this.token.toString(), name: "token from same class");
  }

  void resetSession(context) async {
    this.time = await Timer.periodic(Duration(seconds: 20), (ti) {
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
          log(snapshot.data.toString(), name: "snapshot has data");
          // resetSession(context);

          return Dashboard();
        } else {
          return LoginScreen();
        }
        // if (snapshot.hasData) {
        //   var data = Auth().currentUser;

        //   log(snapshot.data.toString(), name: "value of token");

        //   return Dashboard();
        // } else {
        //   return LoginScreen();
        // }
      },
    );
  }
}
