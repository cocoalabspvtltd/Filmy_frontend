import 'dart:async';
import 'package:dio/src/form_data.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/application_list_response.dart';
import 'package:film/models/common.dart';
import 'package:film/models/hiring_list_response.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/network/api_error_message.dart';
import 'package:film/repository/professionalrepo.dart';
import 'package:film/utils/api_helper.dart';

class ApplicationBloc {
  ProfessionalRepository? _repository;

  ApplicationBloc({this.listener}) {
    if (_repository == null)
      _repository = ProfessionalRepository();
    _applicationController =
    StreamController<ApiResponse<ApplicationListResponse>>.broadcast();

  }
  bool hasNextPage = false;
  int pageNumber = 1;
  int perPage = 10;

  LoadMoreListener? listener;

  late StreamController<ApiResponse<ApplicationListResponse>>
  _applicationController;

  StreamSink<ApiResponse<ApplicationListResponse>>?
  get applicationDetailsListSink => _applicationController.sink;

  Stream<ApiResponse<ApplicationListResponse>>? get applicaionListStream =>
      _applicationController.stream;

  List<Applications> applicationList = [];



  getapplicationList(String id,bool isPagination, {int? perPage}) async {
    if (isPagination) {
      pageNumber = pageNumber + 1;
      listener!.refresh(true);

    } else {
      applicationDetailsListSink!.add(ApiResponse.loading('Fetching Data'));
      pageNumber = 1;
    }
    try {
      ApplicationListResponse response =
      await _repository!.getApplicationList(id,10, pageNumber);
      hasNextPage = response.lastPage! >= pageNumber.toInt()
          ? true
          : false;
      if (isPagination) {
        if (applicationList.length == 0) {
          applicationList = response.applications!;
        } else {
          applicationList.addAll(response.applications!);
        }
      } else {
        applicationList = response.applications! ?? [];
      }
      applicationDetailsListSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        listener!.refresh(false);
      }
    } catch (error, s) {
      Completer().completeError(error, s);
      if (isPagination) {
        listener!.refresh(false);
      } else {
        applicationDetailsListSink!
            .add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    } finally {}
  }




}
