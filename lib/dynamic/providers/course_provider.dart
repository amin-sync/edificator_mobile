import 'package:flutter/foundation.dart';

import '../../commons/generic_response.dart';
import '../../commons/provider_state.dart';
import '../dtos/requests/course/create_course_request.dart';
import '../dtos/requests/course/update_course_request.dart';
import '../dtos/responses/course/course_detail_response.dart';
import '../dtos/responses/course/course_list_by_grade_response.dart';
import '../dtos/responses/course/teacher_course_list_response.dart';
import '../resources/course_resource.dart';

class CourseProvider with ChangeNotifier {
  final CourseResource courseResource = CourseResource();
  GenericResponse? genericResponse;

  ProviderState<List<TeacherCourseListResponse>> teacherCourseListState =
      ProviderState();
  ProviderState<List<CourseListByGradeResponse>> courseListByGradeState =
      ProviderState();
  ProviderState createCourseState = ProviderState();
  ProviderState updateCourseState = ProviderState();

  ProviderState<List<TeacherCourseListResponse>>
      get getTeacherCourseListState => teacherCourseListState;
  ProviderState get getCreateCourseState => createCourseState;
  ProviderState get getUpdateCourseState => updateCourseState;
  ProviderState<List<CourseListByGradeResponse>>
      get getCourseListByGradeState => courseListByGradeState;

  // LIST TEACHER COURSE --------------------------------------------------------------------
  Future<void> listTeacherCourse() async {
    teacherCourseListState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await courseResource.listTeacherCourse();
      teacherCourseListState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => TeacherCourseListResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      teacherCourseListState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // LIST COURSE BY GRADE---------------------------------------------------
  Future<void> listCourseByGrade() async {
    courseListByGradeState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await courseResource.listCourseByGrade();
      courseListByGradeState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => CourseListByGradeResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      courseListByGradeState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // CREATE COURSE --------------------------------------------------------------------
  Future<void> createCourse(CreateCourseRequest request) async {
    createCourseState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await courseResource.createCourse(request);
      createCourseState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      createCourseState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // UPDATE COURSE --------------------------------------------------------------------
  Future<void> updateCourse(UpdateCourseRequest request) async {
    updateCourseState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await courseResource.updateCourse(request);
      updateCourseState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      updateCourseState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  ProviderState<CourseDetailResponse> courseDetailState = ProviderState();

  ProviderState<CourseDetailResponse> get getCourseDetailState =>
      courseDetailState;

  // GET DETAIL ----------------------------------------------------------------
  Future<void> courseDetail(int courseId) async {
    courseDetailState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await courseResource.courseDetail(courseId);
      courseDetailState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? CourseDetailResponse.fromJson(
                  GenericResponse.getData(genericResponse!))
              : null);
    } catch (e) {
      CourseDetailResponse failureResponse = CourseDetailResponse(
          grade: "--",
          fromTime: "--",
          toTime: "--",
          fee: "--",
          expertise: "--",
          fullName: "--",
          days: "--",
          subject: "--",
          profileUrl: "--");
      courseDetailState = ProviderState(
          isLoading: false, success: false, response: failureResponse);
    } finally {
      notifyListeners();
    }
  }
}
