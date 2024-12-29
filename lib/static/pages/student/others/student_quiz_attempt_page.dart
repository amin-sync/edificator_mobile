import 'dart:async';
import 'package:edificators_hub_mobile/commons/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../commons/colors.dart';
import '../../../../commons/toast.dart';
import '../../../../dynamic/dtos/requests/quiz/student_quiz_list_request.dart';
import '../../../../dynamic/dtos/requests/quiz/submit_quiz_request.dart';
import '../../../../dynamic/providers/dashboard_provider.dart';
import '../../../../dynamic/providers/quiz_provider.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/texts/custom_text.dart';

class StudentQuizAttemptPage extends StatefulWidget {
  final int quizId;
  final int courseId;

  const StudentQuizAttemptPage(
      {super.key, required this.quizId, required this.courseId});

  @override
  State<StudentQuizAttemptPage> createState() => _StudentQuizAttemptPageState();
}

class _StudentQuizAttemptPageState extends State<StudentQuizAttemptPage> {
  late Map<int, int> selectedAnswers; // Map of questionId -> answerId
  late Duration quizDuration;
  late int remainingTimeInSeconds;

  @override
  void initState() {
    super.initState();
    selectedAnswers = {};
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final quizzes = quizProvider.getAttemptQuizState.response;
    if (quizzes != null && quizzes.isNotEmpty) {
      String duration =
          quizProvider.getAttemptQuizState.response!.first.duration;
      int durationInMinutes = int.parse(duration.split(' ').first);
      quizDuration = Duration(
        minutes: durationInMinutes,
      );
      remainingTimeInSeconds = quizDuration.inSeconds;
      startTimer();
    }
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (remainingTimeInSeconds > 0) {
        setState(() => remainingTimeInSeconds--);
        startTimer(); // Continue the timer
      } else {
        // Time is up; auto-submit the quiz
        if (mounted) {
          onSubmitPressed();
        }
      }
    });
  }

  void selectAnswer(int questionId, int answerId) {
    setState(() {
      selectedAnswers[questionId] = answerId;
    });
  }

  void onSubmitPressed() async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    int studentId = await SharedPref().readInt("associateId");

    final submitRequest = SubmitQuizRequest(
      quizId: widget.quizId,
      studentId: studentId,
      questionAnwerList: selectedAnswers.entries
          .map((entry) => QuestionAnwerList(
                questionId: entry.key,
                answerId: entry.value,
              ))
          .toList(),
    );

    await quizProvider.submitQuiz(submitRequest);
    if (quizProvider.getSubmitQuizState.success) {
      StudentQuizListRequest request = StudentQuizListRequest(
          studentId: studentId, courseId: widget.courseId);
      await quizProvider.listQuizByStudent(request);
      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      dashboardProvider.getStudentDashboard();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      CustomToast.showToast("Quiz submitted successfully");
    } else {
      CustomToast.showDangerToast("Error submitting quiz");
    }
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final quizzes = quizProvider.getAttemptQuizState.response;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: "Attempt Quiz",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: quizzes == null || quizzes.isEmpty
          ? const Center(child: Text("No questions available"))
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: quiz.question,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColor.blueColor,
                          ),
                          SizedBox(height: height * 0.02),
                          ...[
                            {"id": quiz.answer1Id, "text": quiz.answer1},
                            {"id": quiz.answer2Id, "text": quiz.answer2},
                            if (quiz.answer3 != null)
                              {"id": quiz.answer3Id, "text": quiz.answer3},
                            if (quiz.answer4 != null)
                              {"id": quiz.answer4Id, "text": quiz.answer4},
                          ].map((answer) {
                            return RadioListTile<int>(
                              title: Text(answer["text"]!.toString()),
                              value: int.parse(answer["id"].toString()),
                              groupValue: selectedAnswers[quiz.questionId],
                              onChanged: (value) {
                                selectAnswer(quiz.questionId, value!);
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ));
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: CustomButton(
            textColor: MyColor.redColor,
            text:
                "SUBMIT (${formatDuration(Duration(seconds: remainingTimeInSeconds))})",
            onPressed: () {
              onSubmitPressed();
            },
            backgroundColor: MyColor.tealColor,
          ),
        ),
      ),
    );
  }
}
