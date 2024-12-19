import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../dtos/requests/note/create_note_request.dart';
import '../../commons/generic_response.dart';
import '../../commons/provider_state.dart';
import '../dtos/responses/note_response.dart';
import '../resources/note_resource.dart';

class NotesProvider with ChangeNotifier {
  final NotesResource notesResource = NotesResource();
  GenericResponse? genericResponse;

  ProviderState<List<NoteResponse>> noteListState = ProviderState();
  ProviderState createNoteState = ProviderState();
  ProviderState deleteNoteState = ProviderState();

  ProviderState<List<NoteResponse>> get getNoteListState => noteListState;
  ProviderState get getCreateNoteState => createNoteState;
  ProviderState get getDeleteNoteState => deleteNoteState;

  // LIST NOTES -----------------------------------------------------------
  Future<void> listNotes(int courseId) async {
    noteListState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await notesResource.listNotes(courseId);
      noteListState = ProviderState(
          isLoading: false,
          success: genericResponse!.success,
          response: genericResponse!.success
              ? GenericResponse.getListData(genericResponse!)
                  .map((dynamic e) => NoteResponse.fromJson(e))
                  .toList()
              : null);
    } catch (e) {
      noteListState = ProviderState(
          isLoading: false, success: false, response: List.empty());
    } finally {
      notifyListeners();
    }
  }

  // CREATE NOTE --------------------------------------------------------------------
  Future<void> createNotes(CreateNoteRequest request, XFile file) async {
    createNoteState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await notesResource.createNotes(request, file);
      createNoteState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      createNoteState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // DELETE NOTE --------------------------------------------------------------------
  Future<void> deleteNote(int noteId) async {
    deleteNoteState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await notesResource.deleteNote(noteId);
      deleteNoteState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      deleteNoteState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }
}
