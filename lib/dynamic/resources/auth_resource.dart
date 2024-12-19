import 'dart:convert';

import 'package:edificators_hub_mobile/commons/api_constants.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/auth/login_request.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/auth/student_register_request.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/auth/teacher_regitser_request.dart';
import 'package:edificators_hub_mobile/commons/generic_response.dart';
import 'package:http/http.dart';

class AuthResource {
  // REGISTER TEACHER -----------------------------------------------------
  Future registerTeacher(TeacherRegisterRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/auth/register-teacher"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // REGISTER STUDENT -----------------------------------------------------
  Future registerStudent(StudentRegisterRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/auth/register-student"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // LOGIN --------------------------------------------------------------------
  Future login(LoginRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/auth/login"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }
}
