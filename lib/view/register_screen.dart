import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/appcolors.dart';
import 'package:validators/validators.dart';

import '../resources/components/button.dart';
import '../utilities/message.dart';
import '../view_model/services/auth.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  ValueNotifier<bool> _obsecureText = ValueNotifier(true);

  // text controller
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // focusing pointer
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  // initial age for registration
  double _initialAge = 10;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                child: Container(
                    width: width * .7,
                    height: height * .1,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/app_logo.png')))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  focusNode: _nameFocusNode,
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(
                      "Name",
                    ),
                    prefixIcon: Icon(Icons.face_rounded),
                  ),
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_emailFocusNode),
                ),
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
                    prefixIcon: Icon(Icons.email_rounded),
                  ),
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Age",
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      width: 300,
                      child: Slider(
                        value: _initialAge,
                        min: 10.0,
                        max: 60.0,
                        divisions: 50,
                        onChangeStart: (double value) {
                          print('Start value is ' + value.toString());
                        },
                        onChangeEnd: (double value) {
                          print('Finish value is ' + value.toString());
                        },
                        onChanged: (double newValue) {
                          setState(() {
                            _initialAge = newValue;
                          });
                        },
                        activeColor: AppColors.login_buttonColor,
                        inactiveColor: Colors.black45,
                      ),
                    ),
                    Text(
                      _initialAge.toInt().toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )
                  ],
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
              SizedBox(
                height: height * .09,
              ),
              Buttons(
                text: "Register",
                onPress: () {
                  if (_emailController.text.isEmpty ||
                      !isEmail(_emailController.text)) {
                    Message.flushBarErrorMessage(
                        context, "Enter a valid Email address");
                  } else if (_passwordController.text.length < 6) {
                    Message.flushBarErrorMessage(
                        context, "Password must be at least 6 digits");
                  } else {
                    Auth().createUserWithEmailAndPassword(
                        _emailController.text.toLowerCase().trim(),
                        _passwordController.text.trim());
                    // log("registering ", name: "register");
                    // log(isEmail(_emailController.text).toString(),
                    //     name: "isEmail");
                  }
                },
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text("Don't have an account? "),
              //     TextButton(onPressed: () {}, child: const Text('Sign Up'))
              //   ],
              // )
            ],
          ),
        ],
      ),
    );
  }
}
