// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile_quiz/model/quiz_model.dart';
import 'package:smile_quiz/resources/constants/appcolors.dart';
import 'package:smile_quiz/resources/constants/constants.dart';
import 'package:smile_quiz/resources/constants/textStyle.dart';
import 'package:smile_quiz/utilities/Method/optionsGenerator.dart';
import 'package:smile_quiz/view/summary.dart';
import 'package:smile_quiz/view_model/Question_viewModel.dart';

import '../repository/quiz_question.dart';
import '../resources/components/answerTile.dart';

class QuizPage extends StatefulWidget {
  QuizPage({required this.timeAvailable, required this.gameMode, super.key});

  final timeAvailable;
  bool gameMode;

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

  // constant values
  int questionIndex = 0;
  // accepts only static constant values
  int totalQuestions = AppConstant.totalQuestions;
  int totalScore = 0;
  late double timeLeft;
  late double maxTime;

  // timer
  Timer? _timer;

  List<int> answerOptions = [];

  @override
  void initState() {
    getQuestion();
    timeLeft = widget.timeAvailable;
    maxTime = widget.timeAvailable;
    log("time set $timeLeft", name: "time setted");
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTimer());
    super.initState();
  }

  @override
  void dispose() {
    print("disposed");
    _cancelTimer();
    super.dispose();
  }

  // checking the answer and marking question set as answered
  void questionAnswered(int answered, int correctAnswer) {
    setState(() {
      answerSelected = true;
      _cancelTimer();
    });

    if (answered == correctAnswer) {
      totalScore++;
    }
  }

  // get the question set from the smile api
  getQuestion() async {
    _quizGame = await _quiz_repo.fetchGameQuestionsAPI();
    if (questionIndex != totalQuestions) {
      if (_quizGame != null) {
        setState(() {
          _isLoaded = true; // question loaded
          answerSelected = false; // answer selected status
          answerOptions = []; // answer options
          // get the list of answer options generated
          answerOptions = CustomMethods.getOptions(_quizGame!.solution);
          // increase question index
          questionIndex++;
          if (questionIndex == totalQuestions) {
            endOfQuiz = true;
          }
        });
      }
    } else {
      _cancelTimer();
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => QuizSummary(
                score: totalScore,
                gameMode: widget.gameMode,
              )));
    }
  }

  // reset timer
  void _resetTimer() {
    setState(() {
      timeLeft = widget.timeAvailable;
    });
  }

  // cancel timer
  void _cancelTimer() {
    _timer?.cancel();
  }

// timer functions
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // if this page is still mounted to widget tree then proceed
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
            print(timeLeft);
          } else {
            _cancelTimer();
            answerSelected = true;
          }
        });
      }
    });
  }

  // handling andriod os back button
  Future<bool> _onwillpop() async {
    _cancelTimer();
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onwillpop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appBar_theme,
          leading: IconButton(
              onPressed: () {
                // cancel timer and exit quiz page
                _cancelTimer();
                Navigator.of(context).pop();
              },
              icon: const Icon(CupertinoIcons.back)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (questionIndex != 0)
                  ? Center(
                      child: Text(
                        "${questionIndex} / ${totalQuestions} ",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : null,
            )
          ],
          title: Text('Score : $totalScore'),
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
                          LinearProgressIndicator(
                            value: timeLeft / maxTime,
                            minHeight: 18,
                            backgroundColor: Colors.white,
                            color: Colors.green,
                            semanticsLabel: "time left",
                            semanticsValue: "values",
                          )
                        ],
                      ),
                    ),
                  ),
                  // ************question displaying ***************
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
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.appBar_theme,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                _cancelTimer();
                                _resetTimer();
                                _startTimer();
                                getQuestion();
                              },
                              child: Text(
                                "Skip",
                                style: AppTextStyle.normal,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.appBar_theme,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
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
                                _resetTimer();
                                _startTimer();
                                getQuestion();
                              },
                              child: endOfQuiz
                                  ? Text(
                                      "Submit",
                                      style: AppTextStyle.normal,
                                    )
                                  : Text(
                                      "Next",
                                      style: AppTextStyle.normal,
                                    )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
