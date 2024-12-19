import 'dart:convert';

import 'package:edificators_hub_mobile/commons/shared_pref.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../commons/api_constants.dart';
import '../dtos/requests/user/update_password_request.dart';
import '../../commons/generic_response.dart';
import 'package:http/http.dart' as http;

class UserResource {
  // GET USER PROFILE ---------------------------------------------------------
  Future getUserProfile() async {
    int userId = await SharedPref().readInt("userId");
    Response response = await get(
        Uri.parse("${ApiConstant.backendUrl}/user/get-profile?userId=$userId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // UPLOAD PROFILE PIC -------------------------------------------------------
  Future uploadProfilePic(XFile image) async {
    int userId = await SharedPref().readInt("userId");
    var uri = Uri.parse("${ApiConstant.backendUrl}/user/upload-profile-pic");
    var request = http.MultipartRequest("POST", uri);
    request.fields['userId'] = userId.toString();
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      return GenericResponse.getSuccessResponse();
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // UPDATE PASSWORD ----------------------------------------------------------
  Future updatePassword(UpdatePasswordRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await put(
        Uri.parse("${ApiConstant.backendUrl}/user/update-password"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // LIST TEACHERS BY STUDENT ID ----------------------------------------------
  Future listTeachersByStudentId() async {
    int studentId = await SharedPref().readInt("associateId");
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/user/list-by-student?studentId=$studentId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // LIST STUDENTS BY TEACHER ID ----------------------------------------------
  Future listStudentsByTeacherId() async {
    int teacherId = await SharedPref().readInt("associateId");
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/user/list-by-teacher?teacherId=$teacherId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }
}
