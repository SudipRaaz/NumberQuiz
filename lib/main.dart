import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/utilities/route/routes.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';

//developed on flutter version 3.3.4
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCf1ZbCl7hzOPOAqrmfrNxfmiFCtxplzkE",
          appId: "1:993818877548:web:e946700f298c9d90c48249",
          messagingSenderId: "G-0YLZTT5CVT",
          projectId: "smilequiz"));

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
      initialRoute: RoutesName.splash_Screen,
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
