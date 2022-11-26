import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smile_quiz/resources/constants/appcolors.dart';
import 'package:smile_quiz/resources/constants/textStyle.dart';
import 'package:smile_quiz/utilities/message.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';
import 'package:smile_quiz/view_model/services/Authentication_base.dart';
import 'package:smile_quiz/view_model/services/authentication.dart';
import 'package:smile_quiz/view_model/services/firestore.dart';
import 'package:validators/validators.dart';

import '../resources/components/button.dart';
import '../view_model/services/firebase_abstract.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<bool> _obsecureText = ValueNotifier(true);

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _obsecureText.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    // focus nodes disposed
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  // method to use google authentication for login
  Future googleLogIn() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // creating a obj from a abstract class
    FirebaseBase obj = CloudStore();
    // registering user to cloud firestore from third party authenticators
    obj.registerUser(userCredential.user?.uid,
        userCredential.user!.displayName!, userCredential.user!.email!, 0);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Authenticate obj = Auth();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: AppColors.appBar_theme,
      ),
      body: ListView(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 30),
              child: Container(
                  width: width * .7,
                  height: height * .3,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/app_logo.png')))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: _emailFocusNode,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Email"),
                  // hintText: "abc@gmail.com",
                  prefixIcon: Icon(Icons.email_rounded),
                ),
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(_passwordFocusNode),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: _obsecureText,
                builder: (context, obsecureText, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      obscureText: _obsecureText.value,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Password"),
                          prefixIcon: const Icon(
                            Icons.lock_rounded,
                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                _obsecureText.value = !_obsecureText.value;
                              },
                              child: _obsecureText.value
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility_outlined))),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Forgot Password?"),
                  TextButton(
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          // if email is empty display this message
                          Message.flutterToast(
                              context, 'Enter Email to reset Password');
                        } else {
                          try {
                            // send request for password reset to authentication page
                            obj.passwordReset(
                                context, _emailController.text.trim());
                          } catch (e) {
                            // catch any exception or errors
                            Message.flutterToast(context, e.toString());
                          }
                        }
                      },
                      child: const Text('Reset Password'))
                ],
              ),
            ),
            // 9% gap space occupied
            SizedBox(
              height: height * .04,
            ),
            // widget button
            Buttons(
              text: "Login",
              onPress: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (_emailController.text.isEmpty ||
                    !isEmail(_emailController.text)) {
                  Message.flushBarErrorMessage(
                      context, "Enter a valid Email address");

                  log("enter email", name: "email empty");
                } else if (_passwordController.text.length < 6) {
                  Message.flushBarErrorMessage(
                      context, "Password must be at least 6 digits");
                } else {
                  Auth().signInWithEmailAndPassword(
                      context,
                      _emailController.text.trim(),
                      _passwordController.text.trim());
                }
              },
            ),

            // google sign button styling
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appBar_theme,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    // authentication function configuration
                    googleLogIn();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          "Google Sign In",
                          style: AppTextStyle.normal,
                        ),
                      ),
                    ],
                  )),
            ),

            Text(
              'OR',
              style: AppTextStyle.normal,
            ),

            // Sign Up section text and text button styling
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.register);
                    },
                    child: const Text('Sign Up'))
              ],
            )
          ],
        ),
      ]),
    );
  }
}
