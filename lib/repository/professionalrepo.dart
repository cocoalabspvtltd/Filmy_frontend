import 'dart:async';
import 'package:dio/dio.dart';
import 'package:film/models/common.dart';
import 'package:film/models/hiring_list_response.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/network/api_provider.dart';
import 'package:film/network/apis.dart';
import 'package:film/screens/professional/component/hiring_list_screen.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/user.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../models/hiring.dart';



class ProfessionalRepository {
  ApiProvider? apiClient;

  ProfessionalRepository() {
    if (apiClient == null) apiClient = new ApiProvider();
  }


  Future<ProjectListResponse> getProjectList(int perPage,
      int page) async {
    final response = await apiClient!.getJsonInstance().get(
        '${Apis.fetchProjectList}?page=$page&per_page=$perPage');
    return ProjectListResponse.fromJson(response.data);
  }

  Future<CommonResponse> addProject(FormData body) async {
    Response response = await apiClient!
        .getJsonInstance()
        .post(Apis.storeProject, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> deleteProject(String id) async {
    final response = await apiClient!
        .getJsonInstance()
        .delete('${Apis.deleteProject}$id/delete');
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> editProject(FormData formdata, id) async {
    Response response = await apiClient!
        .getJsonInstance()
        .post('${Apis.editProject}$id/update', data: formdata);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> addHiring( String title, List<int> skillsIds, description, experience, opening,
      salary,ProjectId) async {
    FormData formData = FormData.fromMap({
      "title":title,
      "skills[]":skillsIds,
      "description":description,

    });
    if (experience.isNotEmpty) {
      formData.fields.add(MapEntry("experience", experience));
    }

    if (opening.isNotEmpty) {
      formData.fields.add(MapEntry("openings", opening));
    }

    if (salary.isNotEmpty) {
      formData.fields.add(MapEntry("pay", salary));
    }

    if (ProjectId.isNotEmpty) {
      formData.fields.add(MapEntry("project_id", ProjectId));
    }

    Response response =
    await apiClient!.getJsonInstance().post(Apis.storeHiring, data: formData,
    );
if(response.statusCode==200){
  toastMessage("${response.data['message']}");
  Get.to(()=>PHomeScreen(selectedIndex: 3,));
}
else{
  toastMessage("Check Your enter details");
}
    return CommonResponse.fromJson(response.data);
  }

  Future<HiringListResponse> getHiringList(int perPage,
      int page) async {
    final response = await apiClient!.getJsonInstance().post(
        '${Apis.fetchHiringList}?page=$page&per_page=$perPage');
    print("respo-/.${response}");
    return HiringListResponse.fromJson(response.data);
  }
  Future<HiringHomeresponse> getapplicationList(int perPage,
      int page) async {
    final response = await apiClient!.getJsonInstance().post(
        '${Apis.applicationapply}?page=$page&per_page=$perPage');
    print("respo-/.${response}");
    return HiringHomeresponse.fromJson(response.data);
  }

  Future<CommonResponse> deleteHiring(String id) async {
    final response = await apiClient!
        .getJsonInstance()
        .delete('${Apis.deleteHiring}$id/delete');
    return CommonResponse.fromJson(response.data);
  }
  Future<CommonResponse> editHiring(String id,title, List<int> skillsIds, description, experience, opening,
      salary,ProjectId) async {
    FormData formData = FormData.fromMap({
      "title":title,
      "skills[]":skillsIds,
      "description":description,

    });
    if (experience.isNotEmpty) {
      formData.fields.add(MapEntry("experience", experience));
    }

    if (opening.isNotEmpty) {
      formData.fields.add(MapEntry("openings", opening));
    }

    if (salary.isNotEmpty) {
      formData.fields.add(MapEntry("pay", salary));
    }

    if (ProjectId.isNotEmpty) {
      formData.fields.add(MapEntry("project_id", ProjectId));
    }

    Response response = await apiClient!
        .getJsonInstance()
        .post('${Apis.editHiring}$id/update', data: formData);
    if(response.statusCode==200){
      toastMessage("${response.data['message']}");
      Get.to(()=>PHomeScreen(selectedIndex: 3,));
    }
    else{
      toastMessage("Check Your enter details");
    }
    return CommonResponse.fromJson(response.data);
  }

}
