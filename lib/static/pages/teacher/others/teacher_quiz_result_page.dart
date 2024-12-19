// ignore_for_file: prefer_const_constructors

import 'package:edificators_hub_mobile/commons/api_constants.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/dynamic/providers/quiz_provider.dart';

import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/generic_list.dart';
import '../../../../dynamic/dtos/responses/quiz/quiz_status_response.dart';
import '../../../widgets/cards/status_card.dart';

class TeacherQuizResultPage extends StatefulWidget {
  const TeacherQuizResultPage({super.key});

  @override
  State<TeacherQuizResultPage> createState() => _TeacherQuizResultPageState();
}

class _TeacherQuizResultPageState extends State<TeacherQuizResultPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    //GET QUIZ
    final quizProvider = Provider.of<QuizProvider>(context);
    List<QuizStatusResponse>? results =
        quizProvider.getQuizStatusListState.response;
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
        child: GenericList<QuizStatusResponse>(
          isLoading: quizProvider.getQuizStatusListState.isLoading,
          items: results,
          emptyMessage: "No Results yet",
          itemBuilder: (context, quiz) {
            Widget trailingWidget;
            if (quiz.status == ApiConstant.SUBMITTED) {
              // Pending container for first tile
              trailingWidget = CustomStatusCard(
                text: quiz.status,
                backgroundColor: Colors.green[100]!, // Background color
                textColor: MyColor.greenColor, // Text color
              );
            } else if (quiz.status == ApiConstant.NOT_SUBMIT) {
              // Graded container for third tile
              trailingWidget = CustomStatusCard(
                text: quiz.status,
                backgroundColor: Colors.red[100]!, // Background color
                textColor: MyColor.redColor, // Text color
              );
            } else {
              trailingWidget = SizedBox.shrink();
            }

            return Column(
              children: [
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: quiz.fullName,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MyColor.tealColor,
                      ),
                      SizedBox(height: height * 0.01),
                      CustomText(
                        text:
                            "Marks: ${quiz.marks == "Zero" ? 0 : quiz.marks}/${quiz.outOf}",
                        fontSize: 13,
                        color: MyColor.blueColor,
                      ),
                    ],
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
