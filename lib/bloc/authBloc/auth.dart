import 'dart:async';
import 'dart:io';


import 'package:film/models/login_response.dart';
import 'package:get/get.dart';

import '../../models/common.dart';
import '../../models/profile.dart';
import '../../repository/authrepo.dart';
import '../../screens/professional/p_home_screen.dart';


class AuthBloc {
  AuthRepository? _authRepository;

  AuthBloc() {
    if (_authRepository == null) _authRepository = AuthRepository();
  }

  Future<CommonResponse> userRegistration(String body) async {
    print("jk->${body}");
    try {
      CommonResponse response = await _authRepository!.registerUser(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<LoginResponse> login(String body) async {
    try {
      return await _authRepository!.login(body);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }
  Future<profile> addProperty(
      String image,List<int> idsinterests,address,years,profesion,List<int> idsskill
      ) async {
    try {
      profile response = await _authRepository!.Profileadd(image,idsinterests,address,years,profesion,idsskill);

      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<profile> editProfile(
      String image,List<int> idsinterests,address,years,profesion,List<int> idsskill
      ) async {
    try {
      profile response = await _authRepository!.ProfileUpdate(image,idsinterests,address,years,profesion,idsskill);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }
  Future <dynamic> userprofilecheck() async {
    try {
      final response = await _authRepository!.userprofileornot();
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }
//
// Future<ForgotPassVerifyOtpResponse> resetPasswordVerifyOtp(String otp) async {
//   try {
//     AppDialogs.loading();
//     ForgotPassVerifyOtpResponse response =
//     await _authRepository!.resetPasswordVerifyOtp(otp);
//     Get.back();
//     return response;
//   } catch (e, s) {
//     Get.back();
//     Completer().completeError(e, s);
//     throw e;
//   }
// }
//
// Future<ForgotPassUpdatePassResponse> resetPasswordUpdatePassword(
//     int accountId, String passwordResetToken, String password) async {
//   try {
//     return await _authRepository!
//         .resetPasswordUpdatePassword(accountId, passwordResetToken, password);
//   } catch (e, s) {
//     Completer().completeError(e, s);
//     throw e;
//   }
// }
}
