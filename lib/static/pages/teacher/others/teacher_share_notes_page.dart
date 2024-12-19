import 'package:edificators_hub_mobile/dynamic/dtos/responses/note_response.dart';
import 'package:edificators_hub_mobile/commons/utility.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/widgets/dialogues/share_notes_dialogue.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/generic_list.dart';
import '../../../../dynamic/providers/notes_provider.dart';
import '../../../../commons/toast.dart';

class TeacherShareNotesPage extends StatefulWidget {
  final int courseId;
  const TeacherShareNotesPage({super.key, required this.courseId});

  @override
  State<TeacherShareNotesPage> createState() => _TeacherShareNotesPageState();
}

class _TeacherShareNotesPageState extends State<TeacherShareNotesPage> {
  // ON DELETE
  onDeletePressed(int noteId) async {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    await notesProvider.deleteNote(noteId);
    if (notesProvider.getDeleteNoteState.success) {
      notesProvider.listNotes(widget.courseId);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      CustomToast.showToast("Note deleted successfully");
    } else {
      Navigator.pop(context);
      CustomToast.showToast("Error deleting note");
    }
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    // GET NOTES
    final noteProvider = Provider.of<NotesProvider>(context);
    List<NoteResponse>? notes = noteProvider.getNoteListState.response;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: "Notes",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColor.blueColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GenericList<NoteResponse>(
          isLoading: noteProvider.getNoteListState.isLoading,
          items: notes,
          emptyMessage: "No Notes yet",
          itemBuilder: (context, note) {
            return Container(
              margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: note.title,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MyColor.tealColor,
                        ),
                        SizedBox(height: 5),
                        Text(
                          Utility.getFormattedDate(note.createdOn),
                          style: TextStyle(
                            fontSize: 12,
                            color: MyColor.greyColor,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: MyColor.blueColor),
                      onPressed: () {
                        _showDeleteDialog(context, note.id, setState);
                      },
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ShareNotesDialog(courseId: widget.courseId);
            },
          );
        },
        backgroundColor: MyColor.tealColor,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Note"),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, int noteId, Function updateState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: CustomText(
            text: "Delete",
            fontSize: 22,
            color: MyColor.tealColor,
            fontWeight: FontWeight.w700,
          ),
          content: CustomText(
              text: "Are you sure?", color: MyColor.blueColor, fontSize: 15),
          actions: [
            TextButton(
              onPressed: () {
                updateState(() {
                  onDeletePressed(noteId);
                });
              },
              child: CustomText(
                text: "Yes",
                color: MyColor.blueColor,
                fontSize: 15,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CustomText(
                text: "No",
                color: MyColor.blueColor,
                fontSize: 15,
              ),
            ),
          ],
        );
      },
    );
  }
}
