import 'dart:convert';

import 'package:http/http.dart';

import '../../commons/api_constants.dart';
import '../../commons/generic_response.dart';
import '../dtos/requests/course/create_course_request.dart';
import '../dtos/requests/course/update_course_request.dart';
import '../../commons/shared_pref.dart';

class CourseResource {
  // LIST TEACHER COURSE --------------------------------------------------------------------
  Future listTeacherCourse() async {
    int teacherId = await SharedPref().readInt("associateId");
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/course/list-teacher?teacherId=$teacherId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // LIST COURSE BY GRADE---------------------------------------------------
  Future listCourseByGrade() async {
    int studentId = await SharedPref().readInt("associateId");
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/course/list-by-grade?studentId=$studentId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // CREATE COURSE --------------------------------------------------------------------
  Future createCourse(CreateCourseRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/course/create"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // GET DETAIL --------------------------------------------------------------------
  Future courseDetail(int courseId) async {
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/course/details?courseId=$courseId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // UPDATE COURSE --------------------------------------------------------------------
  Future updateCourse(UpdateCourseRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await put(
        Uri.parse("${ApiConstant.backendUrl}/course/update"),
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
