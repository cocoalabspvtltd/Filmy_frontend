class ApplicationListResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<Applications>? applications;
  int? total;
  int? page;
  int? lastPage;

  ApplicationListResponse(
      {this.success,
        this.statusCode,
        this.message,
        this.applications,
        this.total,
        this.page,
        this.lastPage});

  ApplicationListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['applications'] != null) {
      applications = <Applications>[];
      json['applications'].forEach((v) {
        applications!.add(new Applications.fromJson(v));
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
    if (this.applications != null) {
      data['applications'] = this.applications!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class Applications {
  int? applicationId;
  int? userId;
  int? hiringId;
  Null? projectName;
  String? name;
  String? phone;
  String? email;
  String? comments;
  String? userImage;
  String? status;

  Applications(
      {this.applicationId,
        this.userId,
        this.hiringId,
        this.projectName,
        this.name,
        this.phone,
        this.email,
        this.comments,
        this.userImage,
        this.status});

  Applications.fromJson(Map<String, dynamic> json) {
    applicationId = json['application_id'];
    userId = json['user_id'];
    hiringId = json['hiring_id'];
    projectName = json['project_name'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    comments = json['comments'];
    userImage = json['user_image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['application_id'] = this.applicationId;
    data['user_id'] = this.userId;
    data['hiring_id'] = this.hiringId;
    data['project_name'] = this.projectName;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['comments'] = this.comments;
    data['user_image'] = this.userImage;
    data['status'] = this.status;
    return data;
  }
}