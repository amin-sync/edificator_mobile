import 'package:edificators_hub_mobile/commons/validator.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/note/create_note_request.dart';
import 'package:edificators_hub_mobile/dynamic/providers/notes_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../commons/colors.dart';
import '../buttons/custom_small_button.dart';
import '../fields/custom_field.dart';
import '../../../commons/toast.dart';
import '../texts/custom_text.dart';

class ShareNotesDialog extends StatefulWidget {
  final int courseId;
  const ShareNotesDialog({
    required this.courseId,
    Key? key,
  }) : super(key: key);

  @override
  State<ShareNotesDialog> createState() => _ShareNotesDialogState();
}

class _ShareNotesDialogState extends State<ShareNotesDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  XFile? file;
  String fileName = "No file selected";
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey, // Wrap with Form widget
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Center(
          child: CustomText(
            text: "Share Notes",
            color: MyColor.blueColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomField(
                label: 'Title',
                controller: titleController,
                validator: Validator.title,
              ),
              SizedBox(height: height * 0.01),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02),
                    CustomSmallButton(
                      text: "Choose File",
                      onPressed: () => pickFile(),
                      backgroundColor: MyColor.blueColor,
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      fileName,
                      style: TextStyle(color: MyColor.greyColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomSmallButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cancel",
                    textColor: MyColor.tealColor,
                    backgroundColor: MyColor.whiteColor,
                  ),
                  CustomSmallButton(
                    onPressed: () {
                      // VALIDATE
                      if (_formKey.currentState?.validate() ?? false) {
                        if (file == null || fileName == 'No file selected') {
                          CustomToast.showDangerToast("Upload your file.");
                        } else {
                          // CREATE
                          onCreatePressed(context);
                        }
                      }
                    },
                    text: "Share",
                    backgroundColor: MyColor.tealColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ON CREATE
  onCreatePressed(BuildContext context) async {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    CreateNoteRequest request = CreateNoteRequest(
      title: titleController.text,
      courseId: widget.courseId.toString(),
    );

    await notesProvider.createNotes(request, file!);

    if (notesProvider.getCreateNoteState.success) {
      notesProvider.listNotes(widget.courseId);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      CustomToast.showToast("Note created successfully");
    } else {
      Navigator.pop(context);
      CustomToast.showToast("Error creating note");
    }
  }

  // FILE PICKER
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        setState(() {
          file = XFile(filePath);
          fileName = result.files.single.name;
        });
      }
    }
  }
}
