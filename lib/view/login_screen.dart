import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/appcolors.dart';
import 'package:smile_quiz/utilities/message.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';
import 'package:smile_quiz/view_model/services/Authentication_base.dart';
import 'package:smile_quiz/view_model/services/authentication.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../resources/components/button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

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
                          border: OutlineInputBorder(),
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
              height: height * .09,
            ),
            // widget button
            Buttons(
              text: "Login",
              onPress: () {
                if (_emailController.text.isEmpty) {
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
