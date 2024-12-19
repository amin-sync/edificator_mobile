import 'dart:convert';

CreateQuizRequest createQuizRequestFromJson(String str) =>
    CreateQuizRequest.fromJson(json.decode(str));

String createQuizRequestToJson(CreateQuizRequest data) =>
    json.encode(data.toJson());

class CreateQuizRequest {
  String title;
  String duration;
  int noOfQuestions;
  int courseId;
  List<Question> questions;

  CreateQuizRequest({
    required this.title,
    required this.duration,
    required this.noOfQuestions,
    required this.courseId,
    required this.questions,
  });

  factory CreateQuizRequest.fromJson(Map<String, dynamic> json) =>
      CreateQuizRequest(
        title: json["title"],
        duration: json["duration"],
        noOfQuestions: json["noOfQuestions"],
        courseId: json["courseId"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "duration": duration,
        "noOfQuestions": noOfQuestions,
        "courseId": courseId,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  String text;
  List<Answer> answers;

  Question({
    required this.text,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        text: json["text"],
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
      };
}

class Answer {
  String answer;
  bool correct;

  Answer({
    required this.answer,
    required this.correct,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        answer: json["answer"],
        correct: json["correct"],
      );

  Map<String, dynamic> toJson() => {
        "answer": answer,
        "correct": correct,
      };
}
