class HiringHomeresponse {
  bool? success;
  int? statusCode;
  String? message;
  List<UserHirings>? userHirings;
  int? total;
  int? page;
  int? lastPage;

  HiringHomeresponse(
      {this.success,
        this.statusCode,
        this.message,
        this.userHirings,
        this.total,
        this.page,
        this.lastPage});

  HiringHomeresponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['user_hirings'] != null) {
      userHirings = <UserHirings>[];
      json['user_hirings'].forEach((v) {
        userHirings!.add(new UserHirings.fromJson(v));
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
    if (this.userHirings != null) {
      data['user_hirings'] = this.userHirings!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class UserHirings {
  int? hiringId;
  String? projectName;
  int? userId;
  String? name;
  String? title;
  String? description;
  List<int>? skills;
  String? experience;
  int? projectId;
  String? pay;
  int? openings;
  String? status;
  List<String>? skillNames;

  UserHirings(
      {this.hiringId,
        this.projectName,
        this.userId,
        this.name,
        this.title,
        this.description,
        this.skills,
        this.experience,
        this.projectId,
        this.pay,
        this.openings,
        this.status,
        this.skillNames});

  UserHirings.fromJson(Map<String, dynamic> json) {
    hiringId = json['hiring_id'];
    projectName = json['project_name'];
    userId = json['user_id'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    skills = json['skills'].cast<int>();
    experience = json['experience'];
    projectId = json['project_id'];
    pay = json['pay'];
    openings = json['openings'];
    status = json['status'];
    skillNames = json['skill_names'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hiring_id'] = this.hiringId;
    data['project_name'] = this.projectName;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['skills'] = this.skills;
    data['experience'] = this.experience;
    data['project_id'] = this.projectId;
    data['pay'] = this.pay;
    data['openings'] = this.openings;
    data['status'] = this.status;
    data['skill_names'] = this.skillNames;
    return data;
  }
}