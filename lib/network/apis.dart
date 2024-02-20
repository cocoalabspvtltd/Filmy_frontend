class Apis {
  static String registerUser = 'api/register';
  static String loginUser = 'api/login';
  static String logOutUser='api/logout';
  static String skillList="api/users/skills-list";
  static String userupdate = "api/users/store/user-details";
  //professional
  static String storeProject="api/professionals/projects/store";

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