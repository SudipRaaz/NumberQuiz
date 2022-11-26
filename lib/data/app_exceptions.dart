class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException(this._message, this._prefix); //construcor

  @override
  String toString() {
    return '$_message$_prefix';
  }
}

// Custom exceptions for our application
class FetchDataException extends AppException {
  // ignore: no_leading_underscores_for_local_identifiers
  FetchDataException(String? _message)
      : super(_message, 'Error During Communication');
}

// Custom exceptions for our application
class BadRequestException extends AppException {
  // ignore: no_leading_underscores_for_local_identifiers
  BadRequestException(String? _message) : super(_message, 'Invalid Request');
}

// Custom exceptions for our application
class UnauthorisedException extends AppException {
  // ignore: no_leading_underscores_for_local_identifiers
  UnauthorisedException(String? _message)
      : super(_message, 'Unauthorized Request');
}
