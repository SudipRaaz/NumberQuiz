

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';
import 'package:smile_quiz/view/login_screen.dart';

import '../../view/dashboard.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final argume = settings.arguments;
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());

      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => Dashboard());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("no route defined")),
          );
        });
    }
  }
}
