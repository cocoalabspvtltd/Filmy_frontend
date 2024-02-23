import 'dart:async';
import 'package:dio/src/form_data.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/common.dart';

import 'package:film/models/project_list_response.dart';
import 'package:film/network/api_error_message.dart';
import 'package:film/repository/professionalrepo.dart';
import 'package:film/utils/api_helper.dart';

import '../../models/hiring.dart';

class HiringHomeBloc {
  ProfessionalRepository? _repository;

  HiringHomeBloc({this.listener}) {
    if (_repository == null)
      _repository = ProfessionalRepository();
    _hiringListController =
    StreamController<ApiResponse<HiringHomeresponse>>.broadcast();

  }
  bool hasNextPage = false;
  int pageNumber = 1;
  int perPage = 10;

  LoadMoreListener? listener;

  late StreamController<ApiResponse<HiringHomeresponse>>
  _hiringListController;

  StreamSink<ApiResponse<HiringHomeresponse>>?
  get hiringDetailsListSink => _hiringListController.sink;

  Stream<ApiResponse<HiringHomeresponse>>? get hiringListStream =>
      _hiringListController.stream;

  List<UserHirings> hiringList = [];


  gethiringapplicList(bool isPagination, {int? perPage}) async {
    if (isPagination) {
      pageNumber = pageNumber + 1;
      listener!.refresh(true);

    } else {
      hiringDetailsListSink!.add(ApiResponse.loading('Fetching Data'));
      pageNumber = 1;
    }
    try {
      HiringHomeresponse response =
      await _repository!.getapplicationList(10, pageNumber);
      hasNextPage = response.lastPage! >= pageNumber.toInt()
          ? true
          : false;
      if (isPagination) {
        if (hiringList.length == 0) {
          hiringList = response.userHirings!;
          print("hiring->${hiringList}");
        } else {
          hiringList.addAll(response.userHirings!);
        }
      } else {
        hiringList = response.userHirings! ?? [];
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



}
