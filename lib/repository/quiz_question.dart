import 'package:smile_quiz/data/network/BaseApiServices.dart';
import 'package:smile_quiz/data/network/NetworkApiService.dart';
import 'package:smile_quiz/resources/app_url.dart';

import '../model/quiz_model.dart';

class Quiz_repository {
  BaseApiServices _apiservices = NetworkApiService();

  Future<Question> fetchGameQuestionsAPI() async {
    try {
      dynamic response = await _apiservices.getGetApiResponse(AppURL.quizAPI);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
