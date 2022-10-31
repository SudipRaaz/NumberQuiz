import 'package:flutter/material.dart';
import 'package:smile_quiz/utilities/route/routes.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';

//developed on flutter version 3.3.4
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RoutesName.dashboard,
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
