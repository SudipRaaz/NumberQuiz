import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/constants/appcolors.dart';

// ignore: must_be_immutable
class Buttons extends StatelessWidget {
  // variables for buttons class
  final String text;
  final VoidCallback onPress;

  // constructor
  const Buttons({
    super.key,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // voidcall back functions
        return onPress();
      },
      // container decoration
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.login_buttonColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
