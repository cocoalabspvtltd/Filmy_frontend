import 'dart:async';
import 'package:dio/src/form_data.dart';
import 'package:film/core/load_more_listener.dart';
import 'package:film/models/application_list_response.dart';
import 'package:film/models/application_list_user.dart';
import 'package:film/models/common.dart';
import 'package:film/models/hiring_list_response.dart';
import 'package:film/models/notification_list_response.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/network/api_error_message.dart';
import 'package:film/repository/professionalrepo.dart';
import 'package:film/utils/api_helper.dart';

class ApplicationUserBloc {
  ProfessionalRepository? _repository;

  ApplicationUserBloc({this.listener}) {
    if (_repository == null)
      _repository = ProfessionalRepository();
    _applicationuserController =
    StreamController<ApiResponse<ApplicationList_User>>.broadcast();

    _notificationController =
    StreamController<ApiResponse<NotificationListResponse>>.broadcast();


  }
  bool hasNextPage = false;
  int pageNumber = 1;
  int perPage = 10;

  LoadMoreListener? listener;

  late StreamController<ApiResponse<ApplicationList_User>>
  _applicationuserController;

  StreamSink<ApiResponse<ApplicationList_User>>?
  get applicationuserDetailsListSink => _applicationuserController.sink;

  Stream<ApiResponse<ApplicationList_User>>? get applicaionuserListStream =>
      _applicationuserController.stream;

  List<ApplicationList> applicationListuser = [];


  late StreamController<ApiResponse<NotificationListResponse>>
  _notificationController;

  StreamSink<ApiResponse<NotificationListResponse>>?
  get notificationListSink => _notificationController.sink;

  Stream<ApiResponse<NotificationListResponse>>? get notificationListStream =>
      _notificationController.stream;

  List<Notifications> notificationList = [];



  getapplicationuserList(bool isPagination, {int? perPage}) async {
    if (isPagination) {
      pageNumber = pageNumber + 1;
      listener!.refresh(true);

    } else {
      applicationuserDetailsListSink!.add(ApiResponse.loading('Fetching Data'));
      pageNumber = 1;
    }
    try {
      ApplicationList_User response =
      await _repository!.getapplList(10, pageNumber);
      hasNextPage = response.lastPage! >= pageNumber.toInt()
          ? true
          : false;
      if (isPagination) {
        if (applicationListuser.length == 0) {
          applicationListuser = response.applicationList!;
        } else {
          applicationListuser.addAll(response.applicationList!);
        }
      } else {
        applicationListuser = response.applicationList! ?? [];
      }
      applicationuserDetailsListSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        listener!.refresh(false);
      }
    } catch (error, s) {
      Completer().completeError(error, s);
      if (isPagination) {
        listener!.refresh(false);
      } else {
        applicationuserDetailsListSink!
            .add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    } finally {}
  }


  getnotificationList(bool isPagination, {int? perPage}) async {
    if (isPagination) {
      pageNumber = pageNumber + 1;
      listener!.refresh(true);

    } else {
      notificationListSink!.add(ApiResponse.loading('Fetching Data'));
      pageNumber = 1;
    }
    try {
      NotificationListResponse response =
      await _repository!.getnotificationList(10, pageNumber);
      hasNextPage = response.lastPage! >= pageNumber.toInt()
          ? true
          : false;
      if (isPagination) {
        if (notificationList.length == 0) {
          notificationList = response.notifications!;
        } else {
          notificationList.addAll(response.notifications!);
        }
      } else {
        notificationList = response.notifications! ?? [];
      }
      notificationListSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        listener!.refresh(false);
      }
    } catch (error, s) {
      Completer().completeError(error, s);
      if (isPagination) {
        listener!.refresh(false);
      } else {
        notificationListSink!
            .add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    } finally {}
  }



}
