import 'dart:async';
import 'package:dio/dio.dart';
import 'package:film/models/common.dart';
import 'package:film/models/hiring_list_response.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/network/api_provider.dart';
import 'package:film/network/apis.dart';



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

  Future<CommonResponse> addHiring(String body) async {
    Response response = await apiClient!
        .getJsonInstance()
        .post(Apis.storeHiring, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<HiringListResponse> getHiringList(int perPage,
      int page) async {
    final response = await apiClient!.getJsonInstance().post(
        '${Apis.fetchHiringList}?page=$page&per_page=$perPage');
    print("respo-/.${response}");
    return HiringListResponse.fromJson(response.data);
  }

  Future<CommonResponse> deleteHiring(String id) async {
    final response = await apiClient!
        .getJsonInstance()
        .delete('${Apis.deleteHiring}$id/delete');
    return CommonResponse.fromJson(response.data);
  }
  Future<CommonResponse> editHiring(String body,id) async {
    Response response = await apiClient!
        .getJsonInstance()
        .post('${Apis.editHiring}$id/update', data: body);
    return CommonResponse.fromJson(response.data);
  }

}
