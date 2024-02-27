// import 'dart:async';
// import 'package:dio/src/form_data.dart';
// import 'package:film/core/load_more_listener.dart';
// import 'package:film/models/application_list_response.dart';
// import 'package:film/models/common.dart';
// import 'package:film/models/hiring_list_response.dart';
// import 'package:film/models/project_list_response.dart';
// import 'package:film/network/api_error_message.dart';
// import 'package:film/repository/professionalrepo.dart';
// import 'package:film/utils/api_helper.dart';
//
// import '../../models/application_list_user.dart';
//
// class ApplicationUserBloc {
//   ProfessionalRepository? _repository;
//
//   ApplicationUserBloc({this.listener}) {
//     if (_repository == null)
//       _repository = ProfessionalRepository();
//     _apliactionlistController =
//     StreamController<ApiResponse<ApplicationList_User>>.broadcast();
//
//   }
//   bool hasNextPage = false;
//   int pageNumber = 1;
//   int perPage = 10;
//
//   LoadMoreListener? listener;
//
//   late StreamController<ApiResponse<ApplicationList_User>>?
//   _apliactionlistController;
//
//   StreamSink<ApiResponse<ApplicationList_User>>?
//   get apliactionlistSink => _apliactionlistController?.sink;
//
//   Stream<ApiResponse<ApplicationList_User>>? get apliactionListStream =>
//       _apliactionlistController?.stream;
//
//   List<Applications> applictios = [];
//
//   getapplicationList(bool isPagination, {int? perPage}) async {
//     if (isPagination) {
//       pageNumber = pageNumber + 1;
//       listener!.refresh(true);
//
//     } else {
//       apliactionlistSink?.add(ApiResponse.loading('Fetching Data'));
//       pageNumber = 1;
//     }
//     try {
//       ApplicationList_User response =
//       await _repository!.getapplList(10, pageNumber);
//       hasNextPage = response.lastPage! >= pageNumber.toInt()
//           ? true
//           : false;
//       if (isPagination) {
//         if (applictios.length == 0) {
//           applictios = response.applications!;
//         } else {
//           applictios.addAll(response.applications!);
//         }
//       } else {
//         applictios = response.applications! ?? [];
//       }
//       apliactionlistSink?.add(ApiResponse.completed(response));
//       if (isPagination) {
//         listener!.refresh(false);
//       }
//     } catch (error, s) {
//       Completer().completeError(error, s);
//       if (isPagination) {
//         listener!.refresh(false);
//       } else {
//         apliactionlistSink
//         !
//             .add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
//       }
//     } finally {}
//   }
//
//
//
//
// }
