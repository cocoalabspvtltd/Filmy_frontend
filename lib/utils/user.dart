

class UserDetails {
  static String apiToken = '';
  static String userId = '';
  static String userName = '';
  static String userEmail = '';
  static String userMobile = '';
  static String userDob="";
  static String userAge="";
  static String userGender="";
  static String userRole = '';
  static String userimage="";
  static String userbaseur="";


  static void set(
      String token,
      String id,
      String name,
      String email,
      String mobile,
      String dob,
      String age,
      String gender,
      String role, String image, String baseurl,
      ) {
    apiToken = token;
    userId = id;
    userName = name;
    userEmail = email;
    userMobile = mobile;
    userDob = dob;
    userAge = age;
    userGender =gender;
    userRole = role;
    userimage = image;
    userbaseur = baseurl;

  }
}
