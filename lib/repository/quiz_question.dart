import 'package:smile_quiz/data/network/BaseApiServices.dart';
import 'package:smile_quiz/data/network/NetworkApiService.dart';
import 'package:smile_quiz/resources/constants/app_url.dart';

import '../model/quiz_model.dart';

class QuizRepository {
  // creating the object of NetworkAPiservices from abstract parent class
  final BaseApiServices _apiservices = NetworkApiService();

  // fetching game question
  Future<Question> fetchGameQuestionsAPI() async {
    try {
      // hitting the api URL
      dynamic response = await _apiservices.getGetApiResponse(AppURL.quizAPI);
      // return API response
      return response;
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }
}
