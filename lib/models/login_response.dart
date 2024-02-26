class LoginResponse {
  String? token;
  User? user;
  String? baseUrl;
  bool? success;
  int? status;
  String? message;

  LoginResponse(
      {this.token,
        this.user,
        this.baseUrl,
        this.success,
        this.status,
        this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    baseUrl = json['baseUrl'];
    success = json['success'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['baseUrl'] = this.baseUrl;
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  Null? emailVerifiedAt;
  String? role;
  String? phone;
  String? dob;
  String? gender;
  int? age;
  String? image;
  Null? twoFactorConfirmedAt;
  Null? currentTeamId;
  Null? profilePhotoPath;
  String? status;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? profilePhotoUrl;

  User(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.role,
        this.phone,
        this.dob,
        this.gender,
        this.age,
        this.image,
        this.twoFactorConfirmedAt,
        this.currentTeamId,
        this.profilePhotoPath,
        this.status,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.profilePhotoUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    role = json['role'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
    age = json['age'];
    image = json['image'];
    twoFactorConfirmedAt = json['two_factor_confirmed_at'];
    currentTeamId = json['current_team_id'];
    profilePhotoPath = json['profile_photo_path'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profilePhotoUrl = json['profile_photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['image'] = this.image;
    data['two_factor_confirmed_at'] = this.twoFactorConfirmedAt;
    data['current_team_id'] = this.currentTeamId;
    data['profile_photo_path'] = this.profilePhotoPath;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_photo_url'] = this.profilePhotoUrl;
    return data;
  }
}