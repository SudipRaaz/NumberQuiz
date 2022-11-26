import 'package:smile_quiz/data/network/BaseApiServices.dart';
import 'package:smile_quiz/data/network/NetworkApiService.dart';
import 'package:smile_quiz/resources/constants/app_url.dart';

import '../model/quiz_model.dart';

class QuizRepository {
  final BaseApiServices _apiservices = NetworkApiService();

  Future<Question> fetchGameQuestionsAPI() async {
    try {
      dynamic response = await _apiservices.getGetApiResponse(AppURL.quizAPI);
      return response;
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }
}
