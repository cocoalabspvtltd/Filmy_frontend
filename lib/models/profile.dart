class profile {
  bool? status;
  String? message;
  UserDetails? userDetails;

  profile({this.status, this.message, this.userDetails});

  profile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? skills;
  String? interests;
  String? address;
  String? profession;
  String? years;
  String? resume;
  int? userId;
  String? updatedAt;
  String? createdAt;
  int? id;

  UserDetails(
      {this.skills,
        this.interests,
        this.address,
        this.profession,
        this.years,
        this.resume,
        this.userId,
        this.updatedAt,
        this.createdAt,
        this.id});

  UserDetails.fromJson(Map<String, dynamic> json) {
    skills = json['skills'];
    interests = json['interests'];
    address = json['address'];
    profession = json['profession'];
    years = json['years'];
    resume = json['resume'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skills'] = this.skills;
    data['interests'] = this.interests;
    data['address'] = this.address;
    data['profession'] = this.profession;
    data['years'] = this.years;
    data['resume'] = this.resume;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}