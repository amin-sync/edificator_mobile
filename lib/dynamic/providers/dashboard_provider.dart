import 'package:edificators_hub_mobile/dynamic/resources/dashboard_resource.dart';
import 'package:flutter/cupertino.dart';

import '../../commons/generic_response.dart';
import '../../commons/provider_state.dart';
import '../dtos/responses/student_dashboard_response.dart';
import '../dtos/responses/teacher_dashboard_response.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardResource dashboardResource = DashboardResource();
  GenericResponse? genericResponse;

  ProviderState<TeacherDashboardResponse> teacherDashboardState =
      ProviderState();
  ProviderState<StudentDashboardResponse> studentDashboardState =
      ProviderState();

  ProviderState<TeacherDashboardResponse> get getTeacherDashboardState =>
      teacherDashboardState;
  ProviderState<StudentDashboardResponse> get getStudentDashboardState =>
      studentDashboardState;

  // TEACHER DASHBOARD --------------------------------------------------------
  Future<void> getTeacherDashboard() async {
    teacherDashboardState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await dashboardResource.teacherDashboard();
      teacherDashboardState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? TeacherDashboardResponse.fromJson(
                  GenericResponse.getData(genericResponse!))
              : null);
    } catch (e) {
      TeacherDashboardResponse failureResponse = TeacherDashboardResponse(
          courseCount: 0, enrolledStudentCount: 0, fullName: "--");
      teacherDashboardState = ProviderState(
          isLoading: false, success: false, response: failureResponse);
    } finally {
      notifyListeners();
    }
  }

  // STUDENT DASHBOARD --------------------------------------------------------
  Future<void> getStudentDashboard() async {
    studentDashboardState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await dashboardResource.studentDashboard();
      studentDashboardState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? StudentDashboardResponse.fromJson(
                  GenericResponse.getData(genericResponse!))
              : null);
    } catch (e) {
      StudentDashboardResponse failureResponse = StudentDashboardResponse(
          assignmentCount: 0, quizCount: 0, fullName: "--");
      studentDashboardState = ProviderState(
          isLoading: false, success: false, response: failureResponse);
    } finally {
      notifyListeners();
    }
  }
}
