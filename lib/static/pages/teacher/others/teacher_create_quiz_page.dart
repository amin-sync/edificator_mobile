// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../commons/colors.dart';
import '../../../../dynamic/dtos/requests/quiz/create_quiz_request.dart';
import '../../../../dynamic/providers/quiz_provider.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/dropdown/custom_dropdown.dart';
import '../../../widgets/fields/custom_field.dart';
import '../../../../commons/toast.dart';
import '../../../widgets/texts/custom_text.dart';

class TeacherCreateQuizPage extends StatefulWidget {
  final int courseId;
  const TeacherCreateQuizPage({
    required this.courseId,
    Key? key,
  }) : super(key: key);

  @override
  _TeacherCreateQuizPageState createState() => _TeacherCreateQuizPageState();
}

class _TeacherCreateQuizPageState extends State<TeacherCreateQuizPage> {
  String? selectedDuration;
  String? selectedQuestion;
  int numberOfQuestions = 0;
  final TextEditingController titleController = TextEditingController();

  List<Map<String, TextEditingController>> questionControllers = [];

  void _updateQuestionControllers(int count) {
    setState(() {
      questionControllers = List.generate(count, (index) {
        return {
          "question": TextEditingController(),
          "optionA": TextEditingController(),
          "optionB": TextEditingController(),
          "optionC": TextEditingController(),
          "optionD": TextEditingController(),
          "answer": TextEditingController(),
        };
      });
      numberOfQuestions = count;
    });
  }

  void onCreatePressed(BuildContext context) async {
    // Validate Title
    if (titleController.text.isEmpty) {
      CustomToast.showDangerToast("Please enter a title for the quiz.");
      return;
    }

    // Validate Duration
    if (selectedDuration == null) {
      CustomToast.showDangerToast("Please select a duration for the quiz.");
      return;
    }

    // Validate Number of Questions
    if (numberOfQuestions == 0) {
      CustomToast.showDangerToast("Please specify the number of questions.");
      return;
    }

    // Validate Questions
    for (var i = 0; i < questionControllers.length; i++) {
      final question = questionControllers[i];
      if (question["question"]!.text.isEmpty ||
          question["optionA"]!.text.isEmpty ||
          question["optionB"]!.text.isEmpty ||
          question["optionC"]!.text.isEmpty ||
          question["optionD"]!.text.isEmpty ||
          question["answer"]!.text.isEmpty) {
        CustomToast.showDangerToast(
            "Please fill out all fields for question ${i + 1}.");
        return;
      }
    }

    CreateQuizRequest request = CreateQuizRequest(
      title: titleController.text,
      duration: selectedDuration!,
      noOfQuestions: numberOfQuestions,
      courseId: widget.courseId,
      questions: questionControllers.map((controller) {
        return Question(
          text: controller["question"]!.text,
          answers: [
            Answer(
                answer: controller["optionA"]!.text,
                correct: controller["answer"]!.text == "A"),
            Answer(
                answer: controller["optionB"]!.text,
                correct: controller["answer"]!.text == "B"),
            Answer(
                answer: controller["optionC"]!.text,
                correct: controller["answer"]!.text == "C"),
            Answer(
                answer: controller["optionD"]!.text,
                correct: controller["answer"]!.text == "D"),
          ],
        );
      }).toList(),
    );

    // GET QUIZ
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    await quizProvider.createQuiz(request);
    if (quizProvider.getCreateQuizState.success) {
      quizProvider.listQuizByTeacher(widget.courseId);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      CustomToast.showToast("Quiz created successfully");
    } else {
      CustomToast.showToast("Error creating quiz");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    // Number of questions from 5 to 50
    List<String> noOfQuestions =
        List.generate(46, (index) => (index + 1).toString());

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: "Create Quiz",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MyColor.blueColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 26),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomField(
                label: 'Title',
                controller: titleController,
              ),
              SizedBox(height: height * 0.02),
              CustomDropdown(
                value: selectedDuration,
                options: const ["5 min", "10 min", "15 min", "30 min"],
                label: "Duration",
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDuration = newValue;
                  });
                },
              ),
              SizedBox(height: height * 0.02),
              CustomDropdown(
                value: selectedQuestion,
                options: noOfQuestions,
                label: "No. of questions",
                onChanged: (String? newValue) {
                  int questionCount = int.parse(newValue!);
                  setState(() {
                    selectedQuestion = newValue;
                    _updateQuestionControllers(questionCount);
                  });
                },
              ),
              SizedBox(height: height * 0.02),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfQuestions,
                itemBuilder: (context, index) {
                  var controllers = questionControllers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomField(
                            label: 'Question ${index + 1}',
                            controller: controllers["question"]!,
                          ),
                          SizedBox(height: 10),
                          CustomText(
                            text: "Options",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColor.blueColor,
                          ),
                          SizedBox(height: height * 0.02),
                          CustomField(
                            label: 'A',
                            controller: controllers["optionA"]!,
                          ),
                          SizedBox(height: height * 0.02),
                          CustomField(
                            label: 'B',
                            controller: controllers["optionB"]!,
                          ),
                          SizedBox(height: height * 0.02),
                          CustomField(
                            label: 'C',
                            controller: controllers["optionC"]!,
                          ),
                          SizedBox(height: height * 0.02),
                          CustomField(
                            label: 'D',
                            controller: controllers["optionD"]!,
                          ),
                          SizedBox(height: height * 0.03),
                          CustomDropdown(
                            label: "Correct Answer",
                            options: ["A", "B", "C", "D"],
                            onChanged: (String? newValue) {
                              setState(() {
                                controllers["answer"]!.text = newValue!;
                              });
                            },
                            value: controllers["answer"]!.text.isEmpty
                                ? null
                                : controllers["answer"]!.text,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: CustomButton(
            text: 'Create',
            onPressed: () {
              onCreatePressed(context);
            },
            backgroundColor: MyColor.blueColor,
          ),
        ),
      ),
    );
  }
}
