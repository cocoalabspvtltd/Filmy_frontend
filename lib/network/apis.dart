class Apis {
  static String url = "https://cocoalabs.in/Filmy/public/";
  static String registerUser = 'api/register';
  static String loginUser = 'api/login';
  static String logOutUser='api/logout';
  static String skillList="api/users/skills-list";
  static String userupdate = "api/users/store/user-details";
  static String userforgotpassword = "api/users/forgot-password";
  static String userUpdateprofilepic = "api/users/update_profile_picture";
  static String userSkillList = "api/users/skills-list";
  static String usergallery = "api/users/upload_gallery";
  //professional
  static String storeProject="api/professionals/projects/store";
  static String fetchProjectList="api/professionals/projects/list";

  //college
  static String addComplaint="api/colleges/profiles/store";
  static String fetchCollegeComplaints="api/colleges/profiles/table";
  static String deleteComplaintCollege="api/colleges/profiles/";
  static String editComplaint="api/colleges/profiles/";

  //committee
  static String fetchClaimedList="api/committees/profiles/table";

  //profile
  static String fetchProfileData="api/users/edit";
  static String editProfile="api/users/update";
  static String resetPassword="api/users/change-password";
}