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
    // route setting request cases
    switch (settings.name) {

      // case; requesting for login
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());

      // case; requesting for register
      case RoutesName.register:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Register());

      // case; requesting for dashboard
      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Dashboard());

      // case; requesting for splashScreen
      case RoutesName.splashScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Splash_Screen());

      // case; requesting for leadership Board
      case RoutesName.leadershipBoard:
        return MaterialPageRoute(
            builder: (BuildContext context) => LeaderShipBoard());

      // case; requesting for helpScreen
      case RoutesName.helpScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HelpScreen());

      // case; requesting for terms and conditions
      case RoutesName.termsAndCondition:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TermAndCondition());

      // if non of these above cases are met then return this
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("no route defined")),
          );
        });
    }
  }
}
