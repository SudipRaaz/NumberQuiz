import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile_quiz/view/dashboard.dart';
import 'package:smile_quiz/view/login_screen.dart';
import 'package:smile_quiz/view_model/services/auth.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  String? token;

  @override
  void initState() {
    Auth().setLocalUserToken("adsfadf");
    getUsertoken();
    super.initState();
  }

  getUsertoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = await pref.getString("token");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = Auth().currentUser;
          print(data?.uid);
          print("******* $token ********");

          return Dashboard();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
