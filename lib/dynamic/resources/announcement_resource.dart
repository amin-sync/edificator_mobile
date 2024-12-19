import 'dart:convert';

import 'package:http/http.dart';

import '../../commons/api_constants.dart';
import '../../commons/generic_response.dart';
import '../dtos/requests/announcement/create_announcement_request.dart';

class AnnouncementResource {
  // LIST ANNOUNCEMENT -------------------------------------------------------
  Future listAnnouncement(int courseId) async {
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/announcement/list-by-teacher?courseId=$courseId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // CREATE ANNOUNCEMENT -------------------------------------------------------
  Future createAnnouncement(CreateAnnouncementRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/announcement/create"),
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
