// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// class Quiz extends StatefulWidget {
//   const Quiz({super.key});

//   @override
//   State<Quiz> createState() => _HomeState();
// }

// class _HomeState extends State<Quiz> {
//   Question? quest;
//   List<int> answerOptions = <int>[];

//   bool isLoaded = false;
//   bool answerSelected = false;
//   bool endOfQuiz = false;

//   int questionIndex = 0;
//   int totalQuestions = 10;
//   int totalScore = 0;

//   @override
//   void initState() {
//     super.initState();
//     getQuestion();
//   }

//   void questionAnswered(int answered, int correctAnswer) {
//     setState(() {
//       answerSelected = true;
//     });

//     if (answered == correctAnswer) {
//       totalScore++;
//     }
//   }

//   getQuestion() async {
//     if (questionIndex != totalQuestions) {
//       quest = await Remote().getQuestion();
//       if (quest != null) {
//         setState(() {
//           isLoaded = true;
//           answerSelected = false;
//           answerOptions = [];
//           answerOptions.add(quest!.solution);
//           getRandomNum();
//           answerOptions.shuffle();
//           if (questionIndex == totalQuestions - 1) {
//             questionIndex++;
//             endOfQuiz = true;
//             return;
//           } else {
//             questionIndex++;
//           }
//         });
//       }
//     } else {
//       Navigator.of(context).pop();
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: ((context) => SummaryPage())));
//     }
//   }

//   void getRandomNum() {
//     var random = Random();

//     for (int i = 0; i < 2; i++) {
//       int randomNum = random.nextInt(10);

//       if (i == 0) {
//         if (answerOptions[i] != randomNum) {
//           answerOptions.add(randomNum);
//         } else if (answerOptions[i] == randomNum) {
//           randomNum = random.nextInt(10);
//           answerOptions.add(randomNum);
//         }
//       } else if (i == 1) {
//         if (answerOptions[0] != randomNum && answerOptions[1] != randomNum) {
//           answerOptions.add(randomNum);
//         } else if (answerOptions[0] == randomNum ||
//             answerOptions[1] == randomNum) {
//           randomNum = random.nextInt(10);
//           answerOptions.add(randomNum);
//         }
//       }
//     }
//     print("the list is $answerOptions");
//     print("solution = ${quest?.solution}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(totalScore.toString(),
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           )
//         ],
//         title: Text('Score : ${totalScore}'),
//         leading: Padding(
//           padding: const EdgeInsets.only(top: 18.0, left: 3),
//           child: Text(
//             "${questionIndex} / ${totalQuestions} ",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Visibility(
//         visible: isLoaded,
//         replacement: const Center(
//           child: CircularProgressIndicator(),
//         ),
//         child: Column(
//           children: [
//             // Timer progress bar
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
//               child: Container(
//                 height: 22,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black26, width: 3),
//                     borderRadius: BorderRadius.circular(50)),
//                 child: Stack(
//                   children: [
//                     LayoutBuilder(
//                         builder: (context, Constraints) => Container(
//                               width: Constraints.maxWidth * 0.95,
//                               decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   borderRadius: BorderRadius.circular(50)),
//                             ))
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 8,
//               child: Container(
//                 color: Colors.black38,
//                 height: 300,
//                 width: double.infinity,
//                 child: QuestionPack(quest: quest),
//               ),
//             ),
//             ...List.generate(
//                 answerOptions.length,
//                 (index) => AnswerTile(
//                       answers: answerOptions[index],
//                       answerColor: answerSelected
//                           ? (answerOptions[index] == quest?.solution)
//                               ? Colors.green
//                               : Colors.red
//                           : null,
//                       showIcon: answerSelected
//                           ? (answerOptions[index] == quest?.solution)
//                               ? const Icon(
//                                   Icons.check_circle,
//                                   color: Colors.green,
//                                 )
//                               : const Icon(
//                                   Icons.disabled_by_default_rounded,
//                                   color: Colors.red,
//                                 )
//                           : null,
//                       answerTap: () {
//                         if (answerSelected) {
//                           return;
//                         }
//                         questionAnswered(quest!.solution, answerOptions[index]);
//                       },
//                     )),
//             Expanded(
//               flex: 1,
//               child: Row(
//                 children: [
//                   ElevatedButton(
//                       onPressed: () {
//                         if (!answerSelected) {
//                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                               content: Text(
//                                   "Please select a answer before proceding to Next Question.")));
//                           return;
//                         }
//                         getQuestion();
//                       },
//                       child:
//                           endOfQuiz ? const Text("Submit") : const Text("Next"))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class QuestionPack extends StatelessWidget {
//   const QuestionPack({
//     super.key,
//     required this.quest,
//   });

//   final Question? quest;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       // crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 300,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//               image: DecorationImage(image: NetworkImage("${quest?.question}")),
//               border: Border.all(color: Colors.black38)),
//         ),
//       ],
//     );
//   }
// }
