import 'package:edificators_hub_mobile/commons/api_constants.dart';
import 'package:edificators_hub_mobile/commons/generic_list.dart';
import 'package:edificators_hub_mobile/static/pages/student/others/student_quiz_attempt_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../commons/colors.dart';
import '../../../../dynamic/dtos/responses/quiz/student_quiz_list_response.dart';
import '../../../../dynamic/providers/quiz_provider.dart';
import '../../../widgets/buttons/custom_small_button.dart';
import '../../../widgets/cards/status_card.dart';
import '../../../widgets/texts/custom_text.dart';

class StudentQuizPage extends StatefulWidget {
  final int courseId;
  const StudentQuizPage({
    required this.courseId,
    Key? key,
  }) : super(key: key);

  @override
  State<StudentQuizPage> createState() => _StudentQuizPageState();
}

class _StudentQuizPageState extends State<StudentQuizPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    // GET QUIZ
    final quizProvider = Provider.of<QuizProvider>(context);
    List<StudentQuizListResponse>? quizes =
        quizProvider.getStudentQuizListState.response;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: "Quiz",
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
        child: GenericList<StudentQuizListResponse>(
            isLoading: quizProvider.getStudentQuizListState.isLoading,
            items: quizes,
            emptyMessage: "No Quizzes yet",
            itemBuilder: (context, quiz) {
              final title = quiz.title;
              final status = quiz.status;
              final duration = quiz.duration;
              final marks = quiz.marks;
              final outOf = quiz.outOf;

              return status == ApiConstant.NOT_SUBMIT
                  ? Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
                                  text: duration, // The status text
                                  backgroundColor:
                                      Colors.red[100]!, // Background color
                                  textColor: MyColor.redColor, // Text color
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.007),
                            CustomSmallButton(
                              text: "Attempt",
                              onPressed: () {
                                _showAttemptDialog(quiz.id);
                              },
                              backgroundColor: MyColor.tealColor,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                  text:
                                      "Marks: $marks/$outOf", // The status text
                                  backgroundColor:
                                      Colors.green[100]!, // Background color
                                  textColor: MyColor.greenColor, // Text color
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
            }),
      ),
    );
  }

  void _showAttemptDialog(int quizId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Center(
            child: CustomText(
              text: "Start Quiz ?",
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
                      text: "start",
                      onPressed: () async {
                        // GET QUIZ
                        final quizProvider =
                            Provider.of<QuizProvider>(context, listen: false);
                        await quizProvider.attemptQuiz(quizId);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentQuizAttemptPage(
                              quizId: quizId,
                              courseId: widget.courseId,
                            ),
                          ),
                        );
                      },
                      backgroundColor: MyColor.tealColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
