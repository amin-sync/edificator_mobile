import 'dart:convert';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../../commons/api_constants.dart';
import '../../commons/generic_response.dart';
import '../dtos/requests/assignment/create_assignment_request.dart';
import 'package:http/http.dart' as http;

import '../../commons/utility.dart';
import '../dtos/requests/assignment/grade_assignment_request.dart';
import '../dtos/requests/assignment/student_assignment_list_request.dart';
import '../dtos/requests/assignment/submit_assignment_request.dart';

class AssignmentResource {
  // LIST ASSIGNMENT BY TEACHER -----------------------------------------------
  Future listAssignmentByTeacher(int courseId) async {
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/assignment/list-by-teacher?courseId=$courseId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // LIST ASSIGNMENT BY STUDENT -----------------------------------------------
  Future listAssignmentByStudent(StudentAssignmentListRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/assignment/list-by-student"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // LIST ASSIGNMENT STATUS -----------------------------------------------
  Future listAssignmentStatus(int assignmentId) async {
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/assignment/status-list?assignmentId=$assignmentId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // GRADE ASSIGNMENT ----------------------------------------------------------
  Future gradeAssignment(GradeAssignmentRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/assignment/grade"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // CREATE ASSIGNMENT ---------------------------------------------------------
  Future createAssignment(CreateAssignmentRequest request, XFile file) async {
    var uri = Uri.parse("${ApiConstant.backendUrl}/assignment/create");
    var req = http.MultipartRequest("POST", uri);
    req.fields['title'] = request.title;
    req.fields['dueDate'] = request.dueDate;
    req.fields['courseId'] = request.courseId;

    req.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: Utility.getMediaTypeForFile(file),
    ));

    var response = await req.send();
    if (response.statusCode == 200) {
      return GenericResponse.getSuccessResponse();
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // SUBMIT ASSIGNMENT ---------------------------------------------------------
  Future submitAssignment(SubmitAssignmentRequest request, XFile file) async {
    var uri = Uri.parse("${ApiConstant.backendUrl}/assignment/submit");
    var req = http.MultipartRequest("POST", uri);
    req.fields['assignmentId'] = request.assignmentId;
    req.fields['studentId'] = request.studentId;

    req.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: Utility.getMediaTypeForFile(file),
    ));

    var response = await req.send();
    if (response.statusCode == 200) {
      return GenericResponse.getSuccessResponse();
    } else {
      return GenericResponse.getFailureResponse();
    }
  }
}
