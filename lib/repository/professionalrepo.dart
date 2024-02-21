import 'dart:async';
import 'package:dio/dio.dart';
import 'package:film/models/common.dart';
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

}
