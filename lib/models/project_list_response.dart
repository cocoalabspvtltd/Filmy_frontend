class ProjectListResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<Projects>? projects;
  int? total;
  int? page;
  int? lastPage;

  ProjectListResponse(
      {this.success,
        this.statusCode,
        this.message,
        this.projects,
        this.total,
        this.page,
        this.lastPage});

  ProjectListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['projects'] != null) {
      projects = <Projects>[];
      json['projects'].forEach((v) {
        projects!.add(new Projects.fromJson(v));
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
    if (this.projects != null) {
      data['projects'] = this.projects!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class Projects {
  int? id;
  String? projectName;
  String? type;
  String? description;
  String? poster;
  String? director;
  String? duration;
  String? createdAt;
  String? posterUrl;

  Projects(
      {this.id,
        this.projectName,
        this.type,
        this.description,
        this.poster,
        this.director,
        this.duration,
        this.createdAt,
        this.posterUrl});

  Projects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectName = json['project_name'];
    type = json['type'];
    description = json['description'];
    poster = json['poster'];
    director = json['director'];
    duration = json['duration'];
    createdAt = json['created_at'];
    posterUrl = json['poster_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_name'] = this.projectName;
    data['type'] = this.type;
    data['description'] = this.description;
    data['poster'] = this.poster;
    data['director'] = this.director;
    data['duration'] = this.duration;
    data['created_at'] = this.createdAt;
    data['poster_url'] = this.posterUrl;
    return data;
  }
}