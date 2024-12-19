import 'package:edificators_hub_mobile/commons/api_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../commons/colors.dart';
import '../../../../commons/generic_list.dart';
import '../../../../commons/shared_pref.dart';
import '../../../../commons/toast.dart';
import '../../../../dynamic/dtos/requests/assignment/student_assignment_list_request.dart';
import '../../../../dynamic/dtos/requests/assignment/submit_assignment_request.dart';
import '../../../../dynamic/dtos/requests/download_file_request.dart';
import '../../../../dynamic/dtos/responses/student_assignment_list_response.dart';
import '../../../../dynamic/providers/assignment_provider.dart';
import '../../../../dynamic/providers/dashboard_provider.dart';
import '../../../../dynamic/resources/file_resource.dart';
import '../../../widgets/buttons/custom_icon_button.dart';
import '../../../widgets/cards/status_card.dart';
import '../../../widgets/texts/custom_text.dart';
import '../../../widgets/buttons/custom_small_button.dart';

class StudentAssignmentPage extends StatefulWidget {
  final int courseId;
  const StudentAssignmentPage({super.key, required this.courseId});

  @override
  State<StudentAssignmentPage> createState() => _StudentAssignmentPageState();
}

class _StudentAssignmentPageState extends State<StudentAssignmentPage> {
  XFile? file;
  String fileName = "No file selected";
  String? downloadedFilePath;
  FileResource fileResource = FileResource();

  // ON DOWNLOAD
  onDownloadPressed(String fileName, String type, BuildContext context) async {
    DownloadFileRequest request =
        DownloadFileRequest(fileName: fileName, type: type);
    await fileResource.downloadFile(request, context);
  }

  // ON SUBMIT
  onSubmitPressed(int assignmentId) async {
    int studentId = await SharedPref().readInt("associateId");
    final assignmentProvider =
        Provider.of<AssignmentProvider>(context, listen: false);
    SubmitAssignmentRequest request = SubmitAssignmentRequest(
        assignmentId: assignmentId.toString(), studentId: studentId.toString());

    await assignmentProvider.submitAssignment(request, file!);

    if (assignmentProvider.getSubmitAssignmentState.success) {
      StudentAssignmentListRequest _request = StudentAssignmentListRequest(
          studentId: studentId, courseId: widget.courseId);
      assignmentProvider.listAssignmentByStudent(_request);
      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      dashboardProvider.getStudentDashboard();
      Provider.of<AssignmentProvider>(context, listen: false);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      CustomToast.showToast("Assignment submitted successfully");
    } else {
      Navigator.pop(context);
      CustomToast.showDangerToast("Error submitting assignment");
    }
  }

  // FILE PICKER
  Future<void> pickFile(StateSetter setState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        // Update both parent and dialog states
        setState(() {
          file = XFile(filePath);
          fileName = result.files.single.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    // Get assignments from provider
    final assignmentProvider = Provider.of<AssignmentProvider>(context);
    List<StudentAssignmentListResponse>? assignments =
        assignmentProvider.getStudentAssignmentListState.response;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: "Assignments",
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
        padding: const EdgeInsets.all(16),
        child: GenericList<StudentAssignmentListResponse>(
            isLoading:
                assignmentProvider.getStudentAssignmentListState.isLoading,
            items: assignments,
            emptyMessage: "No Assignments yet",
            itemBuilder: (context, assignment) {
              final title = assignment.title;
              final status = assignment.status;
              final dueDate = assignment.dueDate;
              return assignment.status == ApiConstant.PENDING
                  ? Card(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: title,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: MyColor.blueColor,
                                ),
                                CustomStatusCard(
                                  text: status,
                                  backgroundColor:
                                      Colors.red[100]!, // Background color
                                  textColor: MyColor.redColor, // Text color
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.007),
                            CustomText(
                              text: "Due: $dueDate",
                              fontSize: 14,
                              color: MyColor.greyColor,
                            ),
                            SizedBox(height: height * 0.018),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomSmallButton(
                                  text: "Download",
                                  onPressed: () {
                                    onDownloadPressed(assignment.fileName,
                                        "assignment", context);
                                  },
                                  backgroundColor: MyColor.tealColor,
                                ),
                                CustomSmallButton(
                                  text: "Submit",
                                  onPressed: () {
                                    _showSubmitDialog(assignment.id);
                                  },
                                  backgroundColor: MyColor.tealColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : assignment.status == ApiConstant.SUBMITTED
                      ?
                      // Second Card for "Homework" (Submitted)
                      Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: title,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: MyColor.blueColor,
                                    ),
                                    CustomStatusCard(
                                      text: status,
                                      backgroundColor:
                                          Colors.grey[100]!, // Background color
                                      textColor:
                                          MyColor.greyColor, // Text color
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.007),
                                CustomText(
                                  text: "Due: $dueDate",
                                  fontSize: 14,
                                  color: MyColor.greyColor,
                                ),
                              ],
                            ),
                          ),
                        )
                      :

                      // Third Card for "Homework" (Graded)
                      Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: title,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: MyColor.blueColor,
                                    ),
                                    CustomStatusCard(
                                      text:
                                          "Marks: ${assignment.marks}", // The status text
                                      backgroundColor: Colors
                                          .green[100]!, // Background color
                                      textColor:
                                          MyColor.greenColor, // Text color
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.007),
                                CustomText(
                                  text: "Due: $dueDate",
                                  fontSize: 14,
                                  color: MyColor.greyColor,
                                ),
                              ],
                            ),
                          ),
                        );
            }),
      ),
    );
  }

  void _showSubmitDialog(int assignmentId) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Center(
              child: CustomText(
                text: "Submit",
                fontSize: 22,
                color: MyColor.tealColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconButton(
                    text: "Upload",
                    icon: Icons.file_upload_outlined,
                    backgroundColor: MyColor.blueColor,
                    textColor: MyColor.whiteColor,
                    onPressed: () {
                      pickFile(setState);
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    fileName,
                    style: TextStyle(color: MyColor.greyColor),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomSmallButton(
                        text: "Cancel",
                        textColor: MyColor.blueColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        backgroundColor: MyColor.whiteColor,
                      ),
                      CustomSmallButton(
                        text: "Submit",
                        onPressed: () {
                          if (file == null || fileName == 'No file selected') {
                            CustomToast.showDangerToast("Upload your file.");
                          } else {
                            // SUBMIT
                            onSubmitPressed(assignmentId);
                          }
                        },
                        backgroundColor: MyColor.tealColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
