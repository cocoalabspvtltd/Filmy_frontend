class CommonResponse {
  int? statusCode;
  bool? success;
  String? message;

  CommonResponse({this.statusCode, this.success, this.message});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json["success"];
    message = json['message'];
  }
}
class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse.loading(this.message) : status = Status.LOADING;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
