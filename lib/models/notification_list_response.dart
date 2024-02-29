class NotificationListResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<Notifications>? notifications;
  int? total;
  int? page;
  int? unread;
  int? lastPage;

  NotificationListResponse(
      {this.success,
        this.statusCode,
        this.message,
        this.notifications,
        this.total,
        this.page,
        this.unread,
        this.lastPage});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    unread = json['unread'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['unread'] = this.unread;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class Notifications {
  String? id;
  Data? data;
  String? createdAt;

  Notifications({this.id, this.data, this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Data {
  String? type;
  int? applicationId;
  String? status;
  String? message;

  Data({this.type, this.applicationId, this.status, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    applicationId = json['application_id'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['application_id'] = this.applicationId;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}