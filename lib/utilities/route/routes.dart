import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';
import 'package:smile_quiz/view/login_screen.dart';
import 'package:smile_quiz/view/register_screen.dart';
import 'package:smile_quiz/view/splash_screen.dart';
import 'package:smile_quiz/view/summary.dart';

import '../../view/dashboard.dart';
import '../../view/quizPage.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());

      case RoutesName.register:
        return MaterialPageRoute(builder: (BuildContext context) => Register());

      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => Dashboard());

      case RoutesName.quizPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => QuizPage(
                  timeAvailable: arg,
                ));

      case RoutesName.splash_Screen:
        return MaterialPageRoute(
            builder: (BuildContext context) => Splash_Screen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("no route defined")),
          );
        });
    }
  }
}
