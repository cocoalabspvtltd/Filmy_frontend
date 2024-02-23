import 'dart:async';
import 'package:dio/src/form_data.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/common.dart';
import 'package:film/models/hiring_list_response.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/network/api_error_message.dart';
import 'package:film/repository/professionalrepo.dart';
import 'package:film/utils/api_helper.dart';

class HiringBloc {
  ProfessionalRepository? _repository;

  HiringBloc({this.listener}) {
    if (_repository == null)
      _repository = ProfessionalRepository();
    _hiringListController =
    StreamController<ApiResponse<HiringListResponse>>.broadcast();

  }
  bool hasNextPage = false;
  int pageNumber = 1;
  int perPage = 10;

  LoadMoreListener? listener;

  late StreamController<ApiResponse<HiringListResponse>>
  _hiringListController;

  StreamSink<ApiResponse<HiringListResponse>>?
  get hiringDetailsListSink => _hiringListController.sink;

  Stream<ApiResponse<HiringListResponse>>? get hiringListStream =>
      _hiringListController.stream;

  List<Hirings> hiringList = [];

  gethiringList(bool isPagination, {int? perPage}) async {
    if (isPagination) {
      pageNumber = pageNumber + 1;
      listener!.refresh(true);

    } else {
      hiringDetailsListSink!.add(ApiResponse.loading('Fetching Data'));
      pageNumber = 1;
    }
    try {
      HiringListResponse response =
      await _repository!.getHiringList(10, pageNumber);
      hasNextPage = response.lastPage! >= pageNumber.toInt()
          ? true
          : false;
      if (isPagination) {
        if (hiringList.length == 0) {
          hiringList = response.hirings!;
        } else {
          hiringList.addAll(response.hirings!);
        }
      } else {
        hiringList = response.hirings! ?? [];
      }
      hiringDetailsListSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        listener!.refresh(false);
      }
    } catch (error, s) {
      Completer().completeError(error, s);
      if (isPagination) {
        listener!.refresh(false);
      } else {
        hiringDetailsListSink!
            .add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    } finally {}
  }



  Future<CommonResponse> addHiring(
      String title, List<int> skillsId, description, experience, opening,
      salary,ProjectId
      ) async {
    try {
      CommonResponse response = await _repository!.addHiring( title,  skillsId, description, experience, opening,
          salary,ProjectId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<CommonResponse?> deleteHiring(String Id) async {
    try {
      CommonResponse response = await _repository!
          .deleteHiring(Id);
      toastMessage(response.message);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<CommonResponse> editHiring(id, String title, List<int> skillsId, description, experience, opening,
      salary,ProjectId) async {
    try {
      CommonResponse response = await _repository!.editHiring(id,title,  skillsId, description, experience, opening,
          salary,ProjectId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }


}
