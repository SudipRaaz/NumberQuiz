import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/utilities/route/routes.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';

//developed on flutter version 3.3.4
Future<void> main() async {
  // initializing firebase repository
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // running application on flutter engine
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // truning off the debug check banner
      debugShowCheckedModeBanner: false,
      title: 'Smile Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initial routing to splash screen
      initialRoute: RoutesName.splashScreen,
      // path to generating routes
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
