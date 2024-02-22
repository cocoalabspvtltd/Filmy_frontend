
import 'package:dio/dio.dart';
import 'package:film/models/skillresponse.dart';

import '../network/api_provider.dart';
import '../network/apis.dart';

class ProfileRepository {
  late ApiProvider apiProvider;

  var _dio = Dio();

  WalletRepository() {
    apiProvider = new ApiProvider();
  }
  Future<SkillResponse> getSkillList() async {
    print("object->${await apiProvider.getJsonInstance().get('${Apis.userSkillList}',
    )}");
    final response = await apiProvider.getJsonInstance().get(
      '${Apis.userSkillList}',
    );
    return response.data;
  }

}