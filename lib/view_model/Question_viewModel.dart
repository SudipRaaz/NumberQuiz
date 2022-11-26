import 'package:flutter/cupertino.dart';
import 'package:smile_quiz/data/response/api_response.dart';
import 'package:smile_quiz/model/quiz_model.dart';
import 'package:smile_quiz/repository/quiz_question.dart';

// ignore: camel_case_types
class Question_viewModel with ChangeNotifier {
  final _repository = QuizRepository();

  ApiResponse<Question> questionlist = ApiResponse.loading();

  setQuestion(ApiResponse<Question> response) {
    questionlist = response;
    notifyListeners();
  }

  Future<void> fetchQuestions() async {
    setQuestion(ApiResponse.loading());

    _repository
        .fetchGameQuestionsAPI()
        .then((value) => setQuestion(ApiResponse.complete(value)))
        .onError((error, stackTrace) => ApiResponse.error(error.toString()));
  }
}
