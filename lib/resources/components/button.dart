import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/appcolors.dart';

class Buttons extends StatelessWidget {
  final String text;

  bool loading = false;
  final VoidCallback onPress;
  Buttons(
      {super.key,
      required this.text,
      this.loading = false,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? CircularProgressIndicator()
              : Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                ),
        ),
      ),
    );
  }
}
