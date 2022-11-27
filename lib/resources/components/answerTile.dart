// ignore: file_names
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnswerTile extends StatelessWidget {
  AnswerTile(
      {required this.answerColor,
      required this.answers,
      required this.answerTap,
      required this.showIcon,
      super.key});

  // variable for answer tile widgets
  int answers;
  final Color? answerColor;
  final Function answerTap;
  final Icon? showIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // on tap function call back
        answerTap();
      },
      // container decoration
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 15, right: 15),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: answerColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 0.5,
              ),
              // contaiern box shadow
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 0.8,
                  blurRadius: 5,
                  offset: Offset(3, 7),
                )
              ]),
          child: Row(
            // setting row main axis
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                ),
                child: Text(
                  "Option 1: ",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              // setting dynamic answer option
              Text(
                "$answers",
                style: const TextStyle(fontSize: 22),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: showIcon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
