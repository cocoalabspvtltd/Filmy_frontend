class HiringListResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<Hirings>? hirings;
  int? total;
  int? page;
  int? lastPage;

  HiringListResponse(
      {this.success,
        this.statusCode,
        this.message,
        this.hirings,
        this.total,
        this.page,
        this.lastPage});

  HiringListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['hirings'] != null) {
      hirings = <Hirings>[];
      json['hirings'].forEach((v) {
        hirings!.add(new Hirings.fromJson(v));
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
    if (this.hirings != null) {
      data['hirings'] = this.hirings!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class Hirings {
  int? id;
  String? title;
  String? description;
  List<int>? skills;
  String? experience;
  int? projectId;
  String? pay;
  int? openings;
  String? status;
  List<String>? skillNames;

  Hirings(
      {this.id,
        this.title,
        this.description,
        this.skills,
        this.experience,
        this.projectId,
        this.pay,
        this.openings,
        this.status,
        this.skillNames});

  Hirings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    data['id'] = this.id;
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