import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/generic_list.dart';
import '../../../../commons/utility.dart';
import '../../../../dynamic/dtos/requests/download_file_request.dart';
import '../../../../dynamic/dtos/responses/note_response.dart';
import '../../../../dynamic/providers/notes_provider.dart';
import '../../../../dynamic/resources/file_resource.dart';

class StudentNotesPage extends StatefulWidget {
  final int courseId;
  const StudentNotesPage({super.key, required this.courseId});

  @override
  State<StudentNotesPage> createState() => _StudentNotesPageState();
}

class _StudentNotesPageState extends State<StudentNotesPage> {
  FileResource fileResource = FileResource();

  // ON DOWNLOAD
  onDownloadPressed(String fileName, String type, BuildContext context) async {
    DownloadFileRequest request =
        DownloadFileRequest(fileName: fileName, type: type);
    await fileResource.downloadFile(request, context);
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
                      iconSize: 28,
                      icon: Icon(Icons.file_download_outlined,
                          color: MyColor.blueColor),
                      onPressed: () {
                        onDownloadPressed(note.fileName, "note", context);
                      },
                    ),
                  ),
                  Divider(
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
    );
  }
}

