// ignore_for_file: prefer_const_constructors

import 'package:edificators_hub_mobile/dynamic/dtos/responses/assignment_response.dart';
import 'package:edificators_hub_mobile/dynamic/providers/assignment_provider.dart';
import 'package:edificators_hub_mobile/static/pages/teacher/others/teacher_assignment_status_page.dart';
import 'package:edificators_hub_mobile/static/widgets/dialogues/create_assignment_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/colors.dart';

import '../../../../commons/generic_list.dart';
import '../../../../commons/loader.dart';
import '../../../widgets/texts/custom_text.dart';

class TeacherAssignmentPage extends StatefulWidget {
  final int courseId;
  const TeacherAssignmentPage({super.key, required this.courseId});

  @override
  State<TeacherAssignmentPage> createState() => _TeacherAssignmentPageState();
}

class _TeacherAssignmentPageState extends State<TeacherAssignmentPage> {
  @override
  Widget build(BuildContext context) {
    //GET ANNOUNCEMENT
    final assignmentProvider = Provider.of<AssignmentProvider>(context);
    List<TeacherAssignmentListResponse>? assignments =
        assignmentProvider.getAssignmentListState.response;
    var height = MediaQuery.of(context).size.height;
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
      body: assignmentProvider.getAssignmentListState.isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GenericList<TeacherAssignmentListResponse>(
                isLoading: assignmentProvider.getAssignmentListState.isLoading,
                items: assignments,
                emptyMessage: "No Assignments yet",
                itemBuilder: (context, assignment) {
                  return Card(
                    elevation: 5,
                    color: MyColor.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 4),
                      child: ListTile(
                        title: CustomText(
                          text: assignment.title,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyColor.tealColor,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.009),
                            CustomText(
                              text:
                                  "Due Date: ${assignment.dueDate}",
                              fontSize: 14,
                              color: MyColor.greyColor,
                            ),
                          ],
                        ),
                        onTap: () {
                          // GET ASSIGNMENTS
                          final assignmentProvider =
                              Provider.of<AssignmentProvider>(context,
                                  listen: false);
                          assignmentProvider
                              .listAssignmentStatus(assignment.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TeacherAssignmentStatusPage(
                                      assId: assignment.id,
                                    )),
                          );
                        },
                      ),
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
              return CreateAssignmentDialog(courseId: widget.courseId);
            },
          );
        },
        backgroundColor: MyColor.tealColor,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Assignments"),
      ),
    );
  }
}
