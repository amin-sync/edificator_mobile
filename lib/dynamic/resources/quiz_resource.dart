import 'dart:convert';

import 'package:http/http.dart';

import '../../commons/api_constants.dart';
import '../../commons/generic_response.dart';
import '../dtos/requests/quiz/create_quiz_request.dart';
import '../dtos/requests/quiz/student_quiz_list_request.dart';
import '../dtos/requests/quiz/submit_quiz_request.dart';

class QuizResource {
  // LIST QUIZ BY TEACHER -----------------------------------------------------
  Future listQuizByTeacher(int courseId) async {
    Response response = await get(
        Uri.parse(
            "${ApiConstant.backendUrl}/quiz/list-by-teacher?courseId=$courseId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // LIST QUIZ BY STUDENT -----------------------------------------------------
  Future listQuizByStudent(StudentQuizListRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        body: body,
        Uri.parse("${ApiConstant.backendUrl}/quiz/list-by-student"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // LIST QUIZ STATUS -----------------------------------------------------
  Future listQuizStatus(int quizId) async {
    Response response = await get(
        Uri.parse("${ApiConstant.backendUrl}/quiz/status-list?quizId=$quizId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // ATTEMPT QUIZ -----------------------------------------------------
  Future attemptQuiz(int quizId) async {
    Response response = await get(
        Uri.parse("${ApiConstant.backendUrl}/quiz/attempt?quizId=$quizId"),
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // CREATE QUIZ ---------------------------------------------------------
  Future createQuiz(CreateQuizRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/quiz/create"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // SUMBIT QUIZ ---------------------------------------------------------
  Future submitQuiz(SubmitQuizRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/quiz/submit"),
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
