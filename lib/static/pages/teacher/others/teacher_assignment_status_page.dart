// ignore_for_file: prefer_const_constructors

import 'package:edificators_hub_mobile/commons/api_constants.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/widgets/buttons/custom_small_button.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../commons/generic_list.dart';
import '../../../../dynamic/dtos/responses/assignment_status_response.dart';
import '../../../../dynamic/providers/assignment_provider.dart';
import '../../../widgets/cards/status_card.dart';
import '../../../widgets/dialogues/grade_dialogue.dart';

class TeacherAssignmentStatusPage extends StatefulWidget {
  final int assId;
  const TeacherAssignmentStatusPage({super.key, required this.assId});

  @override
  State<TeacherAssignmentStatusPage> createState() =>
      _TeacherAssignmentStatusPageState();
}

class _TeacherAssignmentStatusPageState
    extends State<TeacherAssignmentStatusPage> {
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    //GET ANNOUNCEMENT
    final assignmentProvider = Provider.of<AssignmentProvider>(context);
    List<AssignmentStatusResponse>? results =
        assignmentProvider.getAssignmentStatusState.response;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: "Results",
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
        child: GenericList<AssignmentStatusResponse>(
          isLoading: assignmentProvider.getAssignmentStatusState.isLoading,
          items: results,
          emptyMessage: "No Results yet",
          itemBuilder: (context, result) {
            Widget trailingWidget;
            if (result.status == ApiConstant.PENDING) {
              trailingWidget = CustomStatusCard(
                text: result.status, // The status text
                backgroundColor: Colors.red[100]!, // Background color
                textColor: MyColor.redColor, // Text color
              );
            } else if (result.status == ApiConstant.SUBMITTED) {
              // Grade button for second tile
              trailingWidget = CustomSmallButton(
                fontSize: 12,
                backgroundColor: MyColor.tealColor,
                text: "Grade",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return GradeDialog(
                        result: result,
                        assId: widget.assId,
                      );
                    },
                  );
                },
              );
            } else if (result.status == ApiConstant.GRADED) {
              trailingWidget = CustomStatusCard(
                text: result.status,
                backgroundColor: Colors.green[100]!, // Background color
                textColor: MyColor.greenColor, // Text color
              );
            } else {
              trailingWidget =
                  SizedBox.shrink(); // Default for extra items if any
            }

            return Column(
              children: [
                ListTile(
                  title: CustomText(
                    text: result.fullName,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColor.tealColor,
                  ),
                  trailing: trailingWidget,
                ),
                Divider(thickness: 1, indent: 10, endIndent: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
