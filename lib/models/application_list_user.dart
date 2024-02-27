class ApplicationList_User {
  bool? success;
  int? statusCode;
  String? message;
  List<ApplicationList>? applicationList;
  int? total;
  int? page;
  int? lastPage;

  ApplicationList_User(
      {this.success,
        this.statusCode,
        this.message,
        this.applicationList,
        this.total,
        this.page,
        this.lastPage});

  ApplicationList_User.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['application_list'] != null) {
      applicationList = <ApplicationList>[];
      json['application_list'].forEach((v) {
        applicationList!.add(new ApplicationList.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.applicationList != null) {
      data['application_list'] =
          this.applicationList!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class ApplicationList {
  int? applicationId;
  int? userId;
  int? hiringId;
  String? hiringRequestName;
  String? comments;
  String? status;

  ApplicationList(
      {this.applicationId,
        this.userId,
        this.hiringId,
        this.hiringRequestName,
        this.comments,
        this.status});

  ApplicationList.fromJson(Map<String, dynamic> json) {
    applicationId = json['application_id'];
    userId = json['user_id'];
    hiringId = json['hiring_id'];
    hiringRequestName = json['hiring_request_name'];
    comments = json['comments'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['application_id'] = applicationId;
    data['user_id'] = this.userId;
    data['hiring_id'] = this.hiringId;
    data['hiring_request_name'] = hiringRequestName;
    data['comments'] = this.comments;
    data['status'] = this.status;
    return data;
  }
}