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
      data['user'] = this.user!;
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
  String? emailVerifiedAt;
  String? role;
  String? phone;
  String? dob;
  String? gender;
  int? age;
  String? image;
  String? twoFactorConfirmedAt;
  String? currentTeamId;
  String? profilePhotoPath;
  String? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? profilePhotoUrl;

  User({
    this.id,
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
    this.profilePhotoUrl,
  });

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
}
