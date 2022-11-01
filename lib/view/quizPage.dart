import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile_quiz/model/quiz_model.dart';
import 'package:smile_quiz/utilities/functions.dart';
import 'package:smile_quiz/view/summary.dart';
import 'package:smile_quiz/view_model/services/Question_viewModel.dart';

import '../repository/quiz_question.dart';
import '../resources/components/answerTile.dart';

class QuizPage extends StatefulWidget {
  QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Question_viewModel questionviewModel = Question_viewModel();
  Question? _quizGame;
  Quiz_repository _quiz_repo = Quiz_repository();

  bool _isLoaded = false;
  bool answerSelected = false;
  bool endOfQuiz = false;

  // should derive from a constant storage class
  int questionIndex = 0;
  int totalQuestions = 5;
  int totalScore = 0;

  List<int> answerOptions = [];

  @override
  void initState() {
    // TODO: implement initState
    getQuestion();
    super.initState();
  }

  // checking the answer and marking question set as answered
  void questionAnswered(int answered, int correctAnswer) {
    setState(() {
      answerSelected = true;
    });

    if (answered == correctAnswer) {
      totalScore++;
    }
  }

  getQuestion() async {
    print(_quizGame); //for test
    _quizGame = await _quiz_repo.fetchGameQuestionsAPI();
    if (questionIndex != totalQuestions) {
      if (_quizGame != null) {
        setState(() {
          _isLoaded = true;
          answerSelected = false;
          answerOptions = [];
          answerOptions = CustomMethods.getOptions(_quizGame!.solution);
          questionIndex++;
          if (questionIndex == totalQuestions) {
            endOfQuiz = true;
          }
        });
      }
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => QuizSummary(
                score: totalScore,
              )));
    }
    print((_quizGame?.question).toString());
    print((_quizGame?.solution).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (questionIndex != 0)
                  ? Text(
                      "${questionIndex} / ${totalQuestions} ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : const Text(""),
            )
          ],
          title: Text('Score : ${totalScore}'),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider<Question_viewModel>(
          create: (context) => questionviewModel,
          child: Consumer<Question_viewModel>(builder: (context, value, child) {
            return Visibility(
              visible: _isLoaded, //isLoaded,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: Column(
                children: [
                  // *************** Timer progress bar *******************
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: Container(
                      height: 22,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26, width: 3),
                          borderRadius: BorderRadius.circular(50)),
                      child: Stack(
                        children: [
                          LayoutBuilder(
                              builder: (context, Constraints) => Container(
                                    width: Constraints.maxWidth * 0.95,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      child: InteractiveViewer(
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      NetworkImage("${_quizGame?.question}")),
                              border: Border.all(color: Colors.black38)),
                        ),
                      ),
                    ),
                  ),

                  // // *********** options tiles generated *******************
                  ...List.generate(
                      answerOptions.length,
                      (index) => AnswerTile(
                            answers: answerOptions[index],
                            answerColor: answerSelected
                                ? (answerOptions[index] == _quizGame?.solution)
                                    ? Colors.green
                                    : Colors.red
                                : Colors.white,
                            showIcon: answerSelected
                                ? (answerOptions[index] == _quizGame?.solution)
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : const Icon(
                                        Icons.disabled_by_default_rounded,
                                        color: Colors.red,
                                      )
                                : null,
                            answerTap: () {
                              if (answerSelected) {
                                return;
                              }
                              questionAnswered(
                                  _quizGame!.solution, answerOptions[index]);
                            },
                          )),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: ElevatedButton(
                              onPressed: () {
                                getQuestion();
                              },
                              child: Text("Skip")),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: ElevatedButton(
                              onPressed: () {
                                if (!answerSelected) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          // action: SnackBarAction(
                                          //     label: "label", onPressed: () {}),
                                          content: Text(
                                              "Please select a answer before proceding to Next Question.")));
                                  return;
                                }
                                getQuestion();
                              },
                              child: endOfQuiz
                                  ? const Text("Submit")
                                  : const Text("Next")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
