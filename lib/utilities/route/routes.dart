import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';
import 'package:smile_quiz/view/login_screen.dart';
import 'package:smile_quiz/view/summary.dart';

import '../../view/dashboard.dart';
import '../../view/quizPage.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final argume = settings.arguments;
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());

      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Dashboard());

      case RoutesName.quizPage:
        return MaterialPageRoute(builder: (BuildContext context) => QuizPage());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("no route defined")),
          );
        });
    }
  }
}
