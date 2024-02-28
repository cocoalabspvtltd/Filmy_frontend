import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:film/models/login_response.dart';
import 'package:film/models/profile.dart';
import 'package:film/screens/homescreens/home_screen.dart';
import 'package:film/screens/professional/component/professionl_home.dart';
import 'package:film/utils/user.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../models/common.dart';
import '../network/api_provider.dart';
import '../network/apis.dart';
import '../screens/professional/p_home_screen.dart';
import '../utils/api_helper.dart';



class AuthRepository {
  ApiProvider? apiClient;

  AuthRepository() {
    if (apiClient == null) apiClient = new ApiProvider();
  }
  Future<CommonResponse> registerUser(String body) async {
    print("bd=>${body}");
    Response response = await apiClient!.getJsonInstance()
        .post(Apis.registerUser, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<LoginResponse> login(String body) async {
    try {
      Response response = await apiClient!.getJsonInstance().post(Apis.loginUser, data: body);
      return LoginResponse.fromJson(response.data);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<profile> Profileadd(String image,List<int> idsskilinterests,address ,years,profesion,List<int> idsskil) async {
    String fileName = image.split('/').last;
    var ImageName =   await MultipartFile.fromFile(image, filename: fileName);
    FormData formData = FormData.fromMap({
      "skills[]":idsskil,
      "interests[]":idsskilinterests,
      "address":address,
      "profession":profesion,
      "years" :years,
      "resume":ImageName
    });
    Response response =
    await apiClient!.getJsonInstance().post(Apis.userupdate, data: formData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data!);
      Get.offAll(()=>PHomeScreen(selectedIndex: 3,));
     toastMessage("Successfully completed your profile");

      return profile.fromJson(response.data);
    } else {
      toastMessage("${response.data['message']}");
      print(
          "###########__________________ADD PROPERTY UNSUCESSFULLY________________##############");
      throw "";
    }
  }
  Future<dynamic> userprofileornot() async {
    Response response =
    await apiClient!.getJsonInstance().get(Apis.userprofilecheck);
    print("resp-=>${response.data}");
    return response.data;
  }
  // getLogoutRepository() async {
  //   try {
  //     Response response =
  //     await apiClient!.getJsonInstance().get(Apis.logOutUser);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print(response.data!);
  //       toastMessage("${response.data['Message']}");
  //       SharedPrefs.logOut();
  //       return response.data;
  //     } else {
  //       toastMessage("${response.data['Message']}");
  //       print(
  //           "###########__________________LOGOUT UNSUCESSFULLY________________##############");
  //       throw "";
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  Future<profile> ProfileUpdate(String image,List<int> idsskilinterests,address ,years,profesion,List<int> idsskil) async {
    FormData formData = FormData.fromMap({
      "skills[]":idsskil,
      "interests[]":idsskilinterests,
    });

    if (image.isNotEmpty) {
      String fileName = image.split('/').last;
      var imageFile = await MultipartFile.fromFile(image, filename: fileName);
      formData.files.add(MapEntry("resume", imageFile));
    }
    if (address.isNotEmpty) {
      formData.fields.add(MapEntry("address", address));
    }
    if (profesion.isNotEmpty) {
      formData.fields.add(MapEntry("profession", profesion));
    }
    if (years.isNotEmpty) {
      formData.fields.add(MapEntry("years", years));
    }
    Response response =
    await apiClient!.getJsonInstance().post(Apis.profileUpdate, data: formData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data!);
      toastMessage("Successfully completed your profile");
      Get.offAll(()=>PHomeScreen(selectedIndex: 3,));
      return profile.fromJson(response.data);
    } else {
      toastMessage("${response.data['message']}");
      print(
          "###########__________________PROFILE UPDATE UNSUCESSFULLY________________##############");
      throw "";
    }
  }

}
