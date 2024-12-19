import 'package:edificators_hub_mobile/commons/validator.dart';
import 'package:edificators_hub_mobile/dynamic/providers/assignment_provider.dart';
import 'package:edificators_hub_mobile/commons/utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../dynamic/dtos/requests/assignment/create_assignment_request.dart';
import '../../../commons/colors.dart';
import '../buttons/custom_small_button.dart';
import '../fields/custom_field.dart';
import '../../../commons/toast.dart';
import '../texts/custom_text.dart';

class CreateAssignmentDialog extends StatefulWidget {
  final int courseId;
  const CreateAssignmentDialog({
    required this.courseId,
    Key? key,
  }) : super(key: key);

  @override
  _CreateAssignmentDialogState createState() => _CreateAssignmentDialogState();
}

class _CreateAssignmentDialogState extends State<CreateAssignmentDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  XFile? file;
  String fileName = "No file selected";
  DateTime? _selectedDate;

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
            text: "Create Assignment",
            fontSize: 22,
            color: MyColor.tealColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomField(
                  label: 'Title',
                  controller: titleController,
                  validator: Validator.title,
                ),
                SizedBox(height: height * 0.01),
                GestureDetector(
                  onTap: () {
                    _pickDate(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColor.blueColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_selectedDate?.toLocal() ?? "Due Date"}"
                              .split(' ')[0],
                          style:
                              TextStyle(color: MyColor.blueColor, fontSize: 16),
                        ),
                        Icon(Icons.calendar_today, color: MyColor.blueColor),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          if (_selectedDate == null) {
                            CustomToast.showDangerToast(
                                "Please chose due date");
                          } else if (file == null ||
                              fileName == 'No file selected') {
                            CustomToast.showDangerToast("Upload your file.");
                          } else {
                            // CREATE
                            onCreatePressed(context);
                          }
                        }
                      },
                      text: "Create",
                      backgroundColor: MyColor.tealColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ON CREATE
  onCreatePressed(BuildContext context) async {
    final assignmentProvider =
        Provider.of<AssignmentProvider>(context, listen: false);
    CreateAssignmentRequest request = CreateAssignmentRequest(
        title: titleController.text,
        courseId: widget.courseId.toString(),
        dueDate: Utility.getFormattedDate(_selectedDate!));

    await assignmentProvider.createAssignment(request, file!);

    if (assignmentProvider.getCreateAssignmentState.success) {
      assignmentProvider.listAssignmentByTeacher(widget.courseId);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      CustomToast.showToast("Assignment created successfully");
    } else {
      Navigator.pop(context);
      CustomToast.showToast("Error creating assignment");
    }
  }

  // DATE PICKER
  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
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
