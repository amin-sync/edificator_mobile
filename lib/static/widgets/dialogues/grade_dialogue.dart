import 'package:edificators_hub_mobile/commons/validator.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/assignment/grade_assignment_request.dart';
import 'package:edificators_hub_mobile/dynamic/providers/assignment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commons/colors.dart';
import '../../../commons/shared_pref.dart';
import '../../../commons/toast.dart';
import '../../../dynamic/dtos/requests/download_file_request.dart';
import '../../../dynamic/dtos/responses/assignment_status_response.dart';
import '../../../dynamic/resources/file_resource.dart';
import '../buttons/custom_icon_button.dart';
import '../buttons/custom_small_button.dart';
import '../dropdown/custom_small_dropdown.dart';
import '../texts/custom_text.dart';

class GradeDialog extends StatefulWidget {
  final int assId;
  final AssignmentStatusResponse? result;
  GradeDialog({
    required this.result,
    required this.assId,
    Key? key,
  }) : super(key: key);

  @override
  _GradeDialogState createState() => _GradeDialogState();
}

class _GradeDialogState extends State<GradeDialog> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGrade;

  FileResource fileResource = FileResource();

  // ON DOWNLOAD
  onDownloadPressed(String fileName, String type, BuildContext context) async {
    DownloadFileRequest request =
        DownloadFileRequest(fileName: fileName, type: type);
    await fileResource.downloadFile(request, context);
  }

  // ON SUBMIT
  void onSubmitPressed() async {
    final quizProvider =
        Provider.of<AssignmentProvider>(context, listen: false);
    int studentId = await SharedPref().readInt("associateId");

    final request = GradeAssignmentRequest(
        assignmentId: widget.assId,
        studentId: studentId,
        marks: selectedGrade ?? "0");
    print(request.toJson());

    await quizProvider.gradeAssignment(request);
    if (quizProvider.getGradeAssignmentState.success) {
      await quizProvider.listAssignmentStatus(widget.assId);
      Navigator.pop(context);
      CustomToast.showToast("Assignment graded successfully");
    } else {
      CustomToast.showDangerToast("Error grading assignment");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    // Create a list of grade options from 1 to 10
    List<String> gradeOptions =
        List.generate(10, (index) => (index + 1).toString());

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Center(
        child: CustomText(
          text: "Grade",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconButton(
                  text: "Download",
                  icon: Icons.download,
                  backgroundColor: MyColor.tealColor,
                  textColor: MyColor.whiteColor,
                  onPressed: () {
                    onDownloadPressed(
                        widget.result?.fileName ?? "", "upload", context);
                  }, // Implement download functionality if needed
                ),
                SizedBox(height: height * 0.02),
                CustomSmallDropdown(
                  value: selectedGrade,
                  options: gradeOptions,
                  label: "Grade",
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGrade = newValue; // Update selected grade
                    });
                  },
                  validator: Validator.gradeValidator,
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomSmallButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cancel action
                      },
                      text: "Cancel",
                      textColor: MyColor.tealColor,
                      backgroundColor: MyColor.whiteColor,
                    ),
                    CustomSmallButton(
                      onPressed: () {
                        onSubmitPressed();
                      },
                      text: "Submit",
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
}
