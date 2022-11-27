// ignore: file_names
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
      // request api URL
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      // forwarding response to return response and storing the return data in responseJson
      responseJson = returnResponse(response);
      // on internet connect error
    } on SocketException {
      FetchDataException('No Internet Connection');
    }
    // return api json response
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      // requeting for post api response
      Response response = await post(Uri.parse(url), body: data)
          // setting timer for 10 seconds
          .timeout(const Duration(seconds: 10));
      // handling exceptinos and storing data in responseJson
      responseJson = returnResponse(response);
      // exceptions handling
    } on SocketException {
      FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        // when everthing is fine return the converted json data
        dynamic responseJson = questionFromJson(response.body);
        return responseJson;

      // else exception handling
      case 400:
        throw BadRequestException(
            "Error accured during communication ${response.statusCode}");
      case 404:
        throw UnauthorisedException(
            "Error accured during communication ${response.statusCode}");
      default:
        throw FetchDataException("Error ${response.statusCode}");
    }
  }
}
