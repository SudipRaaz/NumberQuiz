import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smile_quiz/data/app_exceptions.dart';
import 'package:smile_quiz/data/network/BaseApiServices.dart';
import 'package:http/http.dart' as http;
import 'package:smile_quiz/model/quiz_model.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      Response response =
          await post(Uri.parse(url), body: data).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = questionFromJson(response.body);
        return responseJson;

      case 400:
        throw BadRequestException(
            "Error accured during communication ${response.statusCode}");
      case 500:
      case 404:
        throw UnauthorisedException(
            "Error accured during communication ${response.statusCode}");
      default:
        throw FetchDataException("Error ${response.statusCode}");
    }
  }
}
