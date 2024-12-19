import 'package:edificators_hub_mobile/dynamic/dtos/responses/quiz/attempt_quiz_response.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/responses/quiz/quiz_response.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/responses/quiz/quiz_status_response.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/responses/quiz/student_quiz_list_response.dart';
import 'package:edificators_hub_mobile/dynamic/resources/quiz_resource.dart';
import 'package:flutter/material.dart';

import '../../commons/generic_response.dart';
import '../../commons/provider_state.dart';
import '../dtos/requests/quiz/create_quiz_request.dart';
import '../dtos/requests/quiz/student_quiz_list_request.dart';
import '../dtos/requests/quiz/submit_quiz_request.dart';

class QuizProvider with ChangeNotifier {
  final QuizResource quizResource = QuizResource();
  GenericResponse? genericResponse;

  ProviderState<List<TeacherQuizListResponse>> teacherQuizListState =
      ProviderState();
  ProviderState<List<StudentQuizListResponse>> studentQuizListState =
      ProviderState();
  ProviderState<List<QuizStatusResponse>> quizStatusListState = ProviderState();
  ProviderState<List<AttemptQuizResponse>> attemptQuizState = ProviderState();
  ProviderState createQuizState = ProviderState();
  ProviderState submitQuizState = ProviderState();

  ProviderState<List<TeacherQuizListResponse>> get getTeacherQuizListState =>
      teacherQuizListState;
  ProviderState<List<StudentQuizListResponse>> get getStudentQuizListState =>
      studentQuizListState;
  ProviderState<List<QuizStatusResponse>> get getQuizStatusListState =>
      quizStatusListState;
  ProviderState<List<AttemptQuizResponse>> get getAttemptQuizState =>
      attemptQuizState;
  ProviderState get getCreateQuizState => createQuizState;
  ProviderState get getSubmitQuizState => submitQuizState;

  // LIST QUIZ STATUS -----------------------------------------------------
  Future<void> listQuizStatus(int quizId) async {
    quizStatusListState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await quizResource.listQuizStatus(quizId);
      quizStatusListState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => QuizStatusResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      quizStatusListState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // LIST QUIZ BY TEACHER -----------------------------------------------------
  Future<void> listQuizByTeacher(int courseId) async {
    teacherQuizListState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await quizResource.listQuizByTeacher(courseId);
      teacherQuizListState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => TeacherQuizListResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      teacherQuizListState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // LIST QUIZ BY STUDENT -----------------------------------------------------
  Future<void> listQuizByStudent(StudentQuizListRequest request) async {
    studentQuizListState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await quizResource.listQuizByStudent(request);
      studentQuizListState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => StudentQuizListResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      studentQuizListState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // CREATE QUIZ --------------------------------------------------------------------
  Future<void> createQuiz(CreateQuizRequest request) async {
    createQuizState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await quizResource.createQuiz(request);
      createQuizState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      createQuizState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // SUMBIT QUIZ ---------------------------------------------------------
  Future<void> submitQuiz(SubmitQuizRequest request) async {
    submitQuizState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await quizResource.submitQuiz(request);
      submitQuizState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      submitQuizState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // ATTEMPT QUIZ -----------------------------------------------------
  Future<void> attemptQuiz(int quizId) async {
    attemptQuizState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await quizResource.attemptQuiz(quizId);
      attemptQuizState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => AttemptQuizResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      attemptQuizState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }
}
