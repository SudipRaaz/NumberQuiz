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

// ignore: must_be_immutable
class QuizPage extends StatefulWidget {
  QuizPage({required this.timeAvailable, required this.gameMode, super.key});

  // ignore: prefer_typing_uninitialized_variables
  final timeAvailable; // time available for each quiz questions
  bool gameMode; // game mode selected

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // creating object of question viewmodel
  Question_viewModel questionviewModel = Question_viewModel();
  Question? _quizGame; // creating object of question class
  // ignore: non_constant_identifier_names
  final QuizRepository _quiz_repo = QuizRepository();

  bool _isLoaded =
      false; // is the question loaded from the API (question status)
  bool answerSelected = false; // is answer selected by user
  bool endOfQuiz = false; // have the user reached the end of the quiz

  // constant values
  int questionIndex = 0; // tracking the questio index
  // accepts only static constant values
  int totalQuestions = AppConstant
      .totalQuestions; // total number of question to ask in each game
  int totalScore = 0; // player score tracker
  late double timeLeft; // time remaining for user for each questions
  late double maxTime; // max time available for each questions

  // timer object
  Timer? _timer;
  // list of availble options for each quiz question
  List<int> answerOptions = [];

  @override
  void initState() {
    // getQuestion on page initialization
    getQuestion();
    timeLeft = widget
        .timeAvailable; // time available based on quiz mode selected by user
    maxTime = widget.timeAvailable; // maximum time available for each question
    // log("time set $timeLeft", name: "time setted");
    // after the flutter engine finish building the widget frame start the timer
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTimer());
    super.initState();
  }

  @override
  void dispose() {
    // onpage disposal
    debugPrint("disposed");
    _cancelTimer();
    super.dispose();
  }

  // checking the answer and marking question set as answered
  void questionAnswered(int answered, int correctAnswer) {
    setState(() {
      answerSelected = true; // update answerSelected to true
      _cancelTimer(); // cancel the timer once answered
    });

    if (answered == correctAnswer) {
      // answer selected matches the correctAnswer increment totalScore
      totalScore++;
    }
  }

  // get the question set from the smile api
  getQuestion() async {
    // fetchGame question
    _quizGame = await _quiz_repo.fetchGameQuestionsAPI();
    if (questionIndex != totalQuestions) {
      if (_quizGame != null) {
        // _quizGame is not null
        setState(() {
          _isLoaded = true; // question loaded
          answerSelected = false; // answer selected status
          answerOptions = []; // answer options
          // get the list of answer options generated
          answerOptions = CustomMethods.getOptions(_quizGame!.solution);
          // increase question index
          questionIndex++;
          if (questionIndex == totalQuestions) {
            // questionIndex has reached the end of the question the update endOfQuiz = true
            endOfQuiz = true;
          }
        });
      }
    } else {
      // cancel timer when question ends
      _cancelTimer();
      // dispose current page
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // navigate to quiz summary page with total score secured and gamemode played on
      // ignore: use_build_context_synchronously
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
      // set timer to initial time
      timeLeft = widget.timeAvailable;
    });
  }

  // cancel timer
  void _cancelTimer() {
    _timer?.cancel();
  }

// timer functions
  void _startTimer() {
    // timer frequency
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // if this page is still mounted to widget tree then proceed
      if (mounted) {
        // so that its state can no longer be updated
        setState(() {
          if (timeLeft > 0) {
            // if timeleft is greater than 0
            timeLeft--; // keep decrementing timeleft
            debugPrint(timeLeft.toString());
          } else {
            // else cancel timer
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
                    child: SizedBox(
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
