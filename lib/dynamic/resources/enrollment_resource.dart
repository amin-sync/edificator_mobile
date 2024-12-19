import 'dart:convert';

import 'package:http/http.dart';

import '../../commons/api_constants.dart';
import '../../commons/generic_response.dart';
import '../../commons/shared_pref.dart';

class EnrollmentResource {
  // LIST ENROLLED COURSES -------------------------------------------------
  Future listEnrolledCourses() async {
    int studentId = await SharedPref().readInt("associateId");
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/enrollment/list-student?studentId=$studentId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }
}
