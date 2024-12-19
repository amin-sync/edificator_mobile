import 'package:edificators_hub_mobile/dynamic/resources/announcement_resource.dart';
import 'package:flutter/material.dart';

import '../../commons/generic_response.dart';
import '../../commons/provider_state.dart';
import '../dtos/requests/announcement/create_announcement_request.dart';
import '../dtos/responses/announcement_response.dart';

class AnnouncementProvider with ChangeNotifier {
  final AnnouncementResource announcementResource = AnnouncementResource();
  GenericResponse? genericResponse;

  ProviderState<List<AnnouncementResponse>> announcementListState =
      ProviderState();
  ProviderState createAnnouncementState = ProviderState();

  ProviderState<List<AnnouncementResponse>> get getAnnouncementListState =>
      announcementListState;
  ProviderState get getCreateAnnouncementState => createAnnouncementState;

  // LIST ANNOUNCEMENT --------------------------------------------------------------------
  Future<void> listAnnouncement(int courseId) async {
    announcementListState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await announcementResource.listAnnouncement(courseId);
      announcementListState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => AnnouncementResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      announcementListState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // CREATE ANNOUNCEMENT -------------------------------------------------------
  Future<void> sendAnnouncement(CreateAnnouncementRequest request) async {
    createAnnouncementState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await announcementResource.createAnnouncement(request);
      createAnnouncementState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      createAnnouncementState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }
}
