import 'package:edificators_hub_mobile/dynamic/resources/enrollment_resource.dart';
import 'package:flutter/cupertino.dart';

import '../../commons/generic_response.dart';
import '../../commons/provider_state.dart';
import '../dtos/responses/course/enrolled_courses_response.dart';

class EnrollmentProvider with ChangeNotifier {
  final EnrollmentResource enrollmentResource = EnrollmentResource();
  GenericResponse? genericResponse;

  ProviderState<List<EnrolledCoursesResponse>> enrolledCoursesListState =
      ProviderState();
  ProviderState<List<EnrolledCoursesResponse>>
      get getEnrolledCoursesListState => enrolledCoursesListState;

  // LIST ENROLLED COURSES -------------------------------------------------
  Future<void> listEnrolledCourses() async {
    enrolledCoursesListState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await enrollmentResource.listEnrolledCourses();
      enrolledCoursesListState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => EnrolledCoursesResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      enrolledCoursesListState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }
}
