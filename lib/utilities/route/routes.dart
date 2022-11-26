import 'package:flutter/material.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';
import 'package:smile_quiz/view/help.dart';
import 'package:smile_quiz/view/login_screen.dart';
import 'package:smile_quiz/view/register_screen.dart';
import 'package:smile_quiz/view/splash_screen.dart';
import 'package:smile_quiz/view/termsAndConditions.dart';

import '../../view/dashboard.dart';
import '../../view/leadershipScreen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());

      case RoutesName.register:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Register());

      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Dashboard());

      case RoutesName.splashScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Splash_Screen());

      case RoutesName.leadershipBoard:
        return MaterialPageRoute(
            builder: (BuildContext context) => LeaderShipBoard());

      case RoutesName.helpScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HelpScreen());
      case RoutesName.termsAndCondition:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TermAndCondition());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("no route defined")),
          );
        });
    }
  }
}
