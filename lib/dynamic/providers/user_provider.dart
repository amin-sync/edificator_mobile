import 'dart:io';

import 'package:edificators_hub_mobile/dynamic/dtos/requests/user/update_password_request.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/responses/user/list_student_response.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/responses/user/list_teacher_response.dart';
import 'package:edificators_hub_mobile/dynamic/resources/user_resource.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../commons/generic_response.dart';
import '../../commons/provider_state.dart';
import '../../commons/utility.dart';
import '../dtos/responses/user_profile_response.dart';

class UserProvider with ChangeNotifier {
  final UserResource userResource = UserResource();
  GenericResponse? genericResponse;

  ProviderState<UserProfileResponse> userProfileState = ProviderState();
  ProviderState<List<ListTeacherResponse>> listTeacherState = ProviderState();
  ProviderState<List<ListStudentsResponse>> listStudentState = ProviderState();
  ProviderState uploadProfilePicState = ProviderState();
  ProviderState updatePasswordState = ProviderState();

  ProviderState<UserProfileResponse> get getUserProfileState =>
      userProfileState;
  ProviderState get getUploadProfilePicState => uploadProfilePicState;
  ProviderState get getUpdatePasswordState => updatePasswordState;
  ProviderState get getListTeacherState => listTeacherState;
  ProviderState get getListStudentState => listStudentState;

  // GET USER PROFILE ---------------------------------------------------------
  Future<void> getUserProfile() async {
    userProfileState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await userResource.getUserProfile();
      userProfileState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? UserProfileResponse.fromJson(
                  GenericResponse.getData(genericResponse!))
              : null);
    } catch (e) {
      UserProfileResponse failureResponse =
          UserProfileResponse(email: "--", fullName: "--", profileUrl: null);
      userProfileState = ProviderState(
          isLoading: false, success: false, response: failureResponse);
    } finally {
      notifyListeners();
    }
  }

  // UPLOAD PROFILE PIC -------------------------------------------------------
  Future<void> uploadProfilePic(XFile image) async {
    uploadProfilePicState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      File compressedImage = await Utility.compressImage(File(image.path));
      genericResponse =
          await userResource.uploadProfilePic(XFile(compressedImage.path));
      uploadProfilePicState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      uploadProfilePicState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // UPDATE PASSWORD ----------------------------------------------------------
  Future<void> updatePassword(UpdatePasswordRequest request) async {
    updatePasswordState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await userResource.updatePassword(request);
      updatePasswordState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      updatePasswordState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // LIST TEACHERS BY STUDENT ID ----------------------------------------------
  Future<void> listTeachersByStudentId() async {
    listTeacherState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await userResource.listTeachersByStudentId();
      listTeacherState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => ListTeacherResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      listTeacherState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // LIST STUDENTS BY TEACHER ID ----------------------------------------------
  Future<void> listStudentsByTeacherId() async {
    listStudentState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await userResource.listStudentsByTeacherId();
      listStudentState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => ListStudentsResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      listStudentState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }
}
