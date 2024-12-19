import 'package:edificators_hub_mobile/dynamic/chat/services/chat_service.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/auth/student_register_request.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/responses/login_response.dart';
import 'package:flutter/material.dart';
import '../../commons/provider_state.dart';
import '../dtos/requests/auth/login_request.dart';
import '../dtos/requests/auth/teacher_regitser_request.dart';
import '../../commons/generic_response.dart';
import '../resources/auth_resource.dart';
import '../../commons/shared_pref.dart';

class AuthProvider with ChangeNotifier {
  final AuthResource authResource = AuthResource();
  GenericResponse? genericResponse;

  ProviderState registerTeacherState = ProviderState();
  ProviderState registerStudentState = ProviderState();
  ProviderState<LoginResponse> loginState = ProviderState();

  ProviderState get getRegisterTeacherState => registerTeacherState;
  ProviderState get getRegisterStudentState => registerStudentState;
  ProviderState<LoginResponse> get getLoginState => loginState;

  // REGISTER TEACHER -----------------------------------------------------
  Future<void> registerTeacher(TeacherRegisterRequest request) async {
    registerTeacherState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await authResource.registerTeacher(request);
      registerTeacherState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
      // save chat info
      if (registerTeacherState.success) {
        ChatService.registerChatUser(
            genericResponse!.data.toString(), request.fullName, "");
      }
    } catch (e) {
      registerTeacherState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // REGISTER STUDENT -----------------------------------------------------
  Future<void> registerStudent(StudentRegisterRequest request) async {
    registerStudentState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await authResource.registerStudent(request);
      registerStudentState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);

      // save chat info
      if (registerStudentState.success) {
        ChatService.registerChatUser(
            genericResponse!.data.toString(), request.fullName, "");
      }
    } catch (e) {
      registerStudentState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // LOGIN --------------------------------------------------------------------
  Future<void> login(LoginRequest request) async {
    loginState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await authResource.login(request);
      loginState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? LoginResponse.fromJson(
                  GenericResponse.getData(genericResponse!))
              : null);

      // save login info
      if (loginState.success) {
        SharedPref().savingFieldsDuringLogin(loginState.response);
      }
    } catch (e) {
      loginState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }
}
