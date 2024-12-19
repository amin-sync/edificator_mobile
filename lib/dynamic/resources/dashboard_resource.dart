import 'dart:convert';

import 'package:edificators_hub_mobile/commons/shared_pref.dart';
import 'package:http/http.dart';

import '../../commons/api_constants.dart';
import '../../commons/generic_response.dart';

class DashboardResource {
  // TEACHER DASHBOARD --------------------------------------------------------
  Future teacherDashboard() async {
    int teacherId = await SharedPref().readInt("associateId");
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/dashboard/teacher?teacherId=$teacherId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // STUDENT DASHBOARD --------------------------------------------------------
  Future studentDashboard() async {
    int studentId = await SharedPref().readInt("associateId");
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/dashboard/student?studentId=$studentId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }
}
