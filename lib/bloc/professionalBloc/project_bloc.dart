import 'dart:async';
import 'package:dio/src/form_data.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/common.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/network/api_error_message.dart';
import 'package:film/repository/professionalrepo.dart';
import 'package:film/utils/api_helper.dart';

class ProjectBloc {
  ProfessionalRepository? _repository;

  ProjectBloc({this.listener}) {
    if (_repository == null)
      _repository = ProfessionalRepository();
    _projectListController =
    StreamController<ApiResponse<ProjectListResponse>>.broadcast();

  }
  bool hasNextPage = false;
  int pageNumber = 1;
  int perPage = 10;

  LoadMoreListener? listener;

  late StreamController<ApiResponse<ProjectListResponse>>
  _projectListController;

  StreamSink<ApiResponse<ProjectListResponse>>?
  get projectDetailsListSink => _projectListController.sink;

  Stream<ApiResponse<ProjectListResponse>>? get projectListStream =>
      _projectListController.stream;

  List<Projects> projectList = [];

  getprojectList(bool isPagination, {int? perPage}) async {
    if (isPagination) {
      pageNumber = pageNumber + 1;
      listener!.refresh(true);

    } else {
      projectDetailsListSink!.add(ApiResponse.loading('Fetching Data'));
      pageNumber = 1;
    }
    try {
      ProjectListResponse response =
      await _repository!.getProjectList(20, pageNumber);
      hasNextPage = response.lastPage! >= pageNumber.toInt()
          ? true
          : false;
      if (isPagination) {
        if (projectList.length == 0) {
          projectList = response.projects!;
        } else {
          projectList.addAll(response.projects!);
        }
      } else {
        projectList = response.projects! ?? [];
      }
      projectDetailsListSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        listener!.refresh(false);
      }
    } catch (error, s) {
      Completer().completeError(error, s);
      if (isPagination) {
        listener!.refresh(false);
      } else {
        projectDetailsListSink!
            .add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    } finally {}
  }


  Future<CommonResponse> addProject(FormData formdata) async {
    try {
      CommonResponse response = await _repository!.addProject(formdata);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<CommonResponse?> deleteProject(String Id) async {
    try {
      CommonResponse response = await _repository!
          .deleteProject(Id);
      toastMessage(response.message);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<CommonResponse> editProject(id,FormData formdata) async {
    try {
      CommonResponse response = await _repository!.editProject(formdata,id);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }


}
