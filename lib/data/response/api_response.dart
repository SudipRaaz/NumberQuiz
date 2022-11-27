import 'package:smile_quiz/data/response/status.dart';

class ApiResponse<T> {
  Status? status;
  T? data; // dynamic function
  String? message; // message

  // constructor
  ApiResponse(this.status, this.data, this.message);

  // when api response is loading then set Status loading from super enum class
  ApiResponse.loading() : status = Status.LOADING;

  // when api response is complete then set Status complete from super enum class
  ApiResponse.complete(this.data) : status = Status.COMPLETED;

  // when api response is error then set Status error from super enum class
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return 'Status : $status \n Message : $message \n Data : $data';
  }
}
