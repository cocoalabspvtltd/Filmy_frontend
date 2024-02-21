import 'dart:async';
import 'package:dio/src/form_data.dart';
import 'package:film/models/common.dart';
import 'package:film/repository/professionalrepo.dart';




class ProjectBloc {
  ProfessionalRepository? _repository;


  ProjectBloc() {
    if (_repository == null)
      _repository = ProfessionalRepository();

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


}
