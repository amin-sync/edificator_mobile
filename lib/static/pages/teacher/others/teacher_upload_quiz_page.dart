// ignore_for_file: prefer_const_constructors

import 'package:edificators_hub_mobile/dynamic/dtos/responses/quiz/quiz_response.dart';
import 'package:edificators_hub_mobile/static/pages/teacher/others/teacher_create_quiz_page.dart';
import 'package:edificators_hub_mobile/static/pages/teacher/others/teacher_quiz_result_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/generic_list.dart';
import '../../../../dynamic/providers/quiz_provider.dart';
import '../../../../commons/colors.dart';

import '../../../widgets/texts/custom_text.dart';

class TeacherUploadQuizPage extends StatefulWidget {
  final int courseId;
  const TeacherUploadQuizPage({super.key, required this.courseId});

  @override
  State<TeacherUploadQuizPage> createState() => _TeacherUploadQuizPageState();
}

class _TeacherUploadQuizPageState extends State<TeacherUploadQuizPage> {
  @override
  Widget build(BuildContext context) {
    // GET QUIZ
    final quizProvider = Provider.of<QuizProvider>(context);
    List<TeacherQuizListResponse>? quizes =
        quizProvider.getTeacherQuizListState.response;
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
        child: GenericList<TeacherQuizListResponse>(
          isLoading: quizProvider.getTeacherQuizListState.isLoading,
          items: quizes,
          emptyMessage: "No Quiz yet",
          itemBuilder: (context, quiz) {
            return Card(
              elevation: 5,
              color: MyColor.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: ListTile(
                  title: CustomText(
                    text: quiz.title,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColor.tealColor,
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      text: quiz.duration,
                      fontSize: 14,
                      color: MyColor.greenColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    // GET QUIZ
                    final quizProvider =
                        Provider.of<QuizProvider>(context, listen: false);
                    quizProvider.listQuizStatus(quiz.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeacherQuizResultPage()),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TeacherCreateQuizPage(courseId: widget.courseId),
            ),
          );
        },
        backgroundColor: MyColor.tealColor,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Quiz"),
      ),
    );
  }
}
