import 'package:flutter/cupertino.dart';
import 'package:smile_quiz/data/response/api_response.dart';
import 'package:smile_quiz/model/quiz_model.dart';
import 'package:smile_quiz/repository/quiz_question.dart';

// ignore: camel_case_types
class Question_viewModel with ChangeNotifier {
  // creating object of quizrepository
  final _repository = QuizRepository();
  // Object of APIResponse and setting the status to loading
  ApiResponse<Question> questionlist = ApiResponse.loading();

  // setting question to object of API response
  setQuestion(ApiResponse<Question> response) {
    questionlist = response;
    // notifying listerner about api response
    notifyListeners();
  }

  // future fetchquestions method
  Future<void> fetchQuestions() async {
    // setting quiz question data
    setQuestion(ApiResponse.loading());
    // accessing network layer to hit the API URL
    _repository
        .fetchGameQuestionsAPI()
        // setting the api response and updating the api status to complete
        .then((value) => setQuestion(ApiResponse.complete(value)))
        // on error updating the api response status to error
        .onError((error, stackTrace) => ApiResponse.error(error.toString()));
  }
}
