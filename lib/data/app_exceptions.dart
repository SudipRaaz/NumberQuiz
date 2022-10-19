class AppException implements Exception {
  String? _message;
  String? _prefix;

  AppException(this._message, this._prefix); //construcor

  String toString() {
    return '$_message$_prefix';
  }
}

// Custom exceptions for our application
class FetchDataException extends AppException {
  FetchDataException(String? _message)
      : super(_message, 'Error During Communication');
}

// Custom exceptions for our application
class BadRequestException extends AppException {
  BadRequestException(String? _message) : super(_message, 'Invalid Request');
}

// Custom exceptions for our application
class UnauthorisedException extends AppException {
  UnauthorisedException(String? _message)
      : super(_message, 'Unauthorized Request');
}
