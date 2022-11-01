import 'package:flutter/material.dart';

class QuizSummary extends StatelessWidget {
  QuizSummary({required this.score, super.key});
  int score;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height / 16,
            ),
            Stack(children: [
              CircleAvatar(
                // radius: 110,mi
                maxRadius: 130,
                backgroundColor: Colors.amber[400],
                // backgroundImage: AssetImage("assets/pictures/bronze.jpg"),
              ),
              const Positioned(
                top: 10,
                left: 10,
                child: CircleAvatar(
                  // radius: 110,mi
                  maxRadius: 120,
                  backgroundColor: Color.fromARGB(34, 102, 101, 97),
                  backgroundImage: AssetImage("assets/pictures/bronze.jpg"),
                ),
              ),
            ]),
            SizedBox(
              height: height / 15,
            ),
            Container(child: const Center(child: Text("Quiz Summary"))),
            Text("score : ${score}"),
            Text("High Score : XX"),
          ],
        ),
      ),
    );
  }
}
