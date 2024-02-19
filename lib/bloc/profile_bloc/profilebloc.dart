
import 'dart:async';

import 'package:film/models/skillresponse.dart';
import 'package:film/repository/profilerepo.dart';

import '../../models/common.dart';
import '../../network/api_error_message.dart';

class ProfileBloc {
  ProfileRepository? _profileRepository;
  late StreamController<ApiResponse<SkillResponse>> _getSkillListController = StreamController<ApiResponse<SkillResponse>>();

  StreamSink<ApiResponse<SkillResponse>> get _getskillListSink =>
      _getSkillListController.sink;

  Stream<ApiResponse<SkillResponse>> get getSkillListStream =>
      _getSkillListController.stream;

  ProfileBloc() {
    _getSkillListController = StreamController<ApiResponse<SkillResponse>>();
  }

  void dispose() {
    _getSkillListController.close();
  }


//------------------------------------------------------------------------------

  Future<SkillResponse?> getSkillList() async {
    try {
      _getskillListSink.add(ApiResponse.loading('Fetching'));
print("dsfs");
      SkillResponse response = await _profileRepository!.getSkillList();
      if (response.status ?? false) {
        _getskillListSink.add(ApiResponse.completed(response));
        return response;
      } else {
        _getskillListSink
            .add(ApiResponse.error(response.message ?? 'Something went wrong'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _getskillListSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
    return null;
  }
}