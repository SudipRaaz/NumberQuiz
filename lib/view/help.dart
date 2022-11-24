import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/appcolors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Page'),
        centerTitle: true,
        backgroundColor: AppColors.appBar_theme,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // hpw to start playing
              paragraphHeading("How To Play Quiz?"),
              paragraph(
                  'o From the Home page tab on Play Game Button to start Playing Quiz game.'),
              // how to switch game mode
              paragraphHeading("How to switch game mode?"),
              paragraph(
                  'o From the home page, go to the drawer icons from top left corner where you can see the quiz mode switch then toggle the switch as you want then start playing the game.'),
              // how to get bonus points
              paragraphHeading("How to get bonus points?"),
              paragraph(
                  'o To get bonus score, you need to play the quiz in hard mode. '),
              // how to get bonus points
              paragraphHeading("How to view my total score?"),
              paragraph(
                  'o To view you total score, from home page select the drawer icon on top left, then you will be able to view your total score. '),
            ],
          ),
        ],
      ),
    );
  }

  Widget paragraphHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 8, top: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
