// ignore_for_file: file_names

abstract class BaseApiServices {
  // get API response
  Future<dynamic> getGetApiResponse(String url);

  // get post api response
  Future<dynamic> getPostApiResponse(String url, dynamic data);
}
