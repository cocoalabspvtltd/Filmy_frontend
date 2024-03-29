
import 'package:film/models/login_response.dart';
import 'package:film/screens/authscreens/loginscreen.dart';

import 'package:film/utils/user.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static late SharedPreferences _preferences;

  static String spToken = 'spToken';
  static String spUserId = 'spUserId';
  static String spEmail = 'spEmail';
  static String spName = 'spName';
  static String spMobile = 'spMobile';
  static String spDob = 'spDob';
  static String spAge = "spAge";
  static String spGender = "spGender";
  static String spRole = 'spRole';

  static String spimage = 'spImage';
  static String spbaseurl = 'spBaseurl';
  static String spstatus = "spstatus";


  static init() async {
    _preferences = await SharedPreferences.getInstance();
    User_Details.set(
      getString(spToken),
      getString(spUserId),
      getString(spName),
      getString(spEmail),
      getString(spMobile),
      getString(spDob),
      getString(spAge),
      getString(spGender),
      getString(spRole),
      getString(spimage),
      getString(spbaseurl),
      getString(spstatus)
    );
  }

  static String getString(String key) {
    return _preferences.getString(key) ?? '';
  }

  static Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  static Future<bool> logIn(LoginResponse response) async {
    if (response.user == null) return false;

    String token = response.token ?? User_Details.apiToken;
    String baseurl = response.baseUrl?? User_Details.userbaseur;
    User user = response.user!;
    await setString(spToken, '$token');
    await setString(spUserId, '${user.id ?? ''}');
    await setString(spEmail, '${user.email ?? ''}');
    await setString(spName, '${user.name ?? ''}');
    await setString(spMobile, '${user.phone ?? ''}');
    await setString(spDob, '${user.dob ?? ''}');
    await setString(spAge, '${user.age ?? ''}');
    await setString(spGender, '${user.gender ?? ''}');
    await setString(spRole, '${user.role ?? ''}');
    await setString(spimage, '${user.image ?? ''}');
    await setString(spbaseurl, '$baseurl');
    await setString(spstatus, "${user.status}");

    User_Details.set(
      token,
      '${user.id ?? ''}',
      '${user.name ?? ''}',
      '${user.email ?? ''}',
      '${user.phone ?? ''}',
      '${user.dob ?? ''}',
      '${user.age ?? ''}',
      '${user.gender ?? ''}',
      '${user.role ?? ''}',
      "${user.image??""}",
      baseurl,
      "${user.status}"

    );
    return true;
  }

  static Future<bool> logOut() async {
    await _preferences.clear();

    User_Details.set('', '', '', '', '', '', '', '', '',"",'',"");

    Get.offAll(() => LoginScreen());
    return true;
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  static bool getBool(String key) {
    return _preferences.getBool(key) ?? false;
  }
}
