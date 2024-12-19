import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../commons/api_constants.dart';
import '../dtos/requests/note/create_note_request.dart';
import '../../commons/generic_response.dart';
import '../../commons/utility.dart';

class NotesResource {
  // LIST NOTES -------------------------------------------------------
  Future listNotes(int courseId) async {
    Response response = await get(
        Uri.parse("${ApiConstant.backendUrl}/note/list?courseId=$courseId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // CREATE NOTES ---------------------------------------------------------
  Future createNotes(CreateNoteRequest request, XFile file) async {
    var uri = Uri.parse("${ApiConstant.backendUrl}/note/create");
    var req = http.MultipartRequest("POST", uri);
    req.fields['title'] = request.title;
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

  // DELETE NOTE ------------------------------------------------------------
  Future deleteNote(int noteId) async {
    Response response = await delete(
        Uri.parse("${ApiConstant.backendUrl}/note/delete?noteId=$noteId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }
}
