class Apis {
  static String storageUrl="https://cocoalabs.in/Filmy/public/storage/";
  static String url = "https://cocoalabs.in/Filmy/public/";
  static String registerUser = 'api/register';
  static String loginUser = 'api/login';
  static String logOutUser='api/logout';
  //static String skillList="api/users/skills-list";
  static String userupdate = "api/store/user-details";
  static String userforgotpassword = "api/users/forgot-password";

  static String userprofilecheck = "api/user-status";
  static String userSkillList = "api/skills-list";
  static String usergallery = "api/users/upload_gallery";
  static String fetchgallery = "api/users/gallery";
  //professional
  static String storeProject="api/professionals/projects/store";
  static String fetchProjectList="api/professionals/projects/list";
  static String deleteProject="api/professionals/projects/";
  static String editProject="api/professionals/projects/";
  static String storeHiring="api/professionals/hiring/requests/store";
  static String fetchHiringList="api/professionals/hiring/requests/list";
  static String professUpdateprofilepic = "api/update_profile_picture";
  static String profupdate = "api/users/store/user-details";
  static String deleteHiring="api/professionals/hiring/requests/";
  static String editHiring="api/professionals/hiring/requests/";
  static String applicationapply = "api/users/hiring/requests/list";
  static String fetchApplicationList = "api/professionals/hiring/requests/applications/";
  static String fetchappliedlist ="api/applications/applied-requests";
  static String rejectOrAccept="api/professionals/hiring/requests/applications/";
  static String profileUpdate = "api/update/user-details";
  static String fetchUserdetails = "api/user-details";
 // static String applicationapplypro = "api/professionals/hiring/requests/list";
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