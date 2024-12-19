import 'package:edificators_hub_mobile/dynamic/resources/assignment_resource.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../commons/generic_response.dart';
import '../../commons/provider_state.dart';
import '../dtos/requests/assignment/create_assignment_request.dart';
import '../dtos/requests/assignment/grade_assignment_request.dart';
import '../dtos/requests/assignment/student_assignment_list_request.dart';
import '../dtos/requests/assignment/submit_assignment_request.dart';
import '../dtos/responses/assignment_response.dart';
import '../dtos/responses/assignment_status_response.dart';
import '../dtos/responses/student_assignment_list_response.dart';

class AssignmentProvider with ChangeNotifier {
  final AssignmentResource assignmentResource = AssignmentResource();
  GenericResponse? genericResponse;

  ProviderState<List<TeacherAssignmentListResponse>>
      teacherAssignmentListState = ProviderState();
  ProviderState<List<StudentAssignmentListResponse>>
      studentAssignmentListState = ProviderState();
  ProviderState<List<AssignmentStatusResponse>> assignmentStatusState =
      ProviderState();
  ProviderState createAssignmentState = ProviderState();
  ProviderState submitAssignmentState = ProviderState();
  ProviderState gradeAssignmentState = ProviderState();

  ProviderState<List<TeacherAssignmentListResponse>>
      get getAssignmentListState => teacherAssignmentListState;
  ProviderState<List<StudentAssignmentListResponse>>
      get getStudentAssignmentListState => studentAssignmentListState;
  ProviderState<List<AssignmentStatusResponse>> get getAssignmentStatusState =>
      assignmentStatusState;
  ProviderState get getCreateAssignmentState => createAssignmentState;
  ProviderState get getSubmitAssignmentState => submitAssignmentState;
  ProviderState get getGradeAssignmentState => gradeAssignmentState;

  // LIST ASSIGNMENT BY TEACHER -----------------------------------------------
  Future<void> listAssignmentByTeacher(int courseId) async {
    teacherAssignmentListState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse =
          await assignmentResource.listAssignmentByTeacher(courseId);
      teacherAssignmentListState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => TeacherAssignmentListResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      teacherAssignmentListState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // LIST ASSIGNMENT BY STUDENT -----------------------------------------------
  Future<void> listAssignmentByStudent(
      StudentAssignmentListRequest request) async {
    studentAssignmentListState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse =
          await assignmentResource.listAssignmentByStudent(request);
      studentAssignmentListState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => StudentAssignmentListResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      studentAssignmentListState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // LIST ASSIGNMENT STATUS -----------------------------------------------
  Future<void> listAssignmentStatus(int assignmentId) async {
    assignmentStatusState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse =
          await assignmentResource.listAssignmentStatus(assignmentId);
      assignmentStatusState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => AssignmentStatusResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      assignmentStatusState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // CREATE ASSIGNMENT --------------------------------------------------------------------
  Future<void> createAssignment(
      CreateAssignmentRequest request, XFile file) async {
    createAssignmentState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse =
          await assignmentResource.createAssignment(request, file);
      createAssignmentState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      createAssignmentState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // SUBMIT ASSIGNMENT --------------------------------------------------------------------
  Future<void> submitAssignment(
      SubmitAssignmentRequest request, XFile file) async {
    submitAssignmentState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse =
          await assignmentResource.submitAssignment(request, file);
      submitAssignmentState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      submitAssignmentState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // GRADE ASSIGNMENT --------------------------------------------------------------------
  Future<void> gradeAssignment(GradeAssignmentRequest request) async {
    gradeAssignmentState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await assignmentResource.gradeAssignment(request);
      gradeAssignmentState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      gradeAssignmentState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }
}
