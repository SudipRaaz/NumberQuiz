import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smile_quiz/utilities/message.dart';
import 'package:smile_quiz/view_model/services/auth.dart';

import '../resources/components/button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ValueNotifier<bool> _obsecureText = ValueNotifier(true);

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();

  FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              focusNode: _emailFocusNode,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
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
          SizedBox(
            height: height * 0.09,
          ),
          Buttons(
            text: "Login",
            onPress: () {
              if (_emailController.text.isEmpty) {
                Message.flushBarErrorMessage(
                    context, "Enter a valid Email address");
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
          )
        ],
      ),
    );
  }
}
