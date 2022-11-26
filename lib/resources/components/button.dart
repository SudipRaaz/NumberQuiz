import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/constants/appcolors.dart';

// ignore: must_be_immutable
class Buttons extends StatelessWidget {
  final String text;

  bool loading = false;
  final VoidCallback onPress;
  Buttons({
    super.key,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        loading = true;
        return onPress();
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.login_buttonColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: loading
              ? const CircularProgressIndicator()
              : Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget button_login(String text, bool loading, VoidCallback onPress) {
  return InkWell(
    onTap: onPress,
    child: Container(
      decoration: BoxDecoration(
          color: AppColors.login_buttonColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: loading
            ? const CircularProgressIndicator()
            : Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget gradientButton(String lable, Function VoidCallback) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: Stack(
      children: [
        Positioned.fill(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            const Color.fromARGB(255, 4, 135, 243),
            Colors.blue.shade300,
            Colors.blue.shade200
          ], end: Alignment.topCenter, begin: Alignment.bottomCenter)),
        )),
        TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(20)),
            onPressed: () {
              VoidCallback;
            },
            child: Text(
              lable,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ))
      ],
    ),
  );
}

Widget submitButton() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 15),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2)
        ],
        gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)])),
    child: const Text(
      'Login',
      style: TextStyle(fontSize: 20, color: Colors.white),
    ),
  );
}
