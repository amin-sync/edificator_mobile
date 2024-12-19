import 'dart:convert';

SubmitQuizRequest submitQuizRequestFromJson(String str) =>
    SubmitQuizRequest.fromJson(json.decode(str));

String submitQuizRequestToJson(SubmitQuizRequest data) =>
    json.encode(data.toJson());

class SubmitQuizRequest {
  int quizId;
  int studentId;
  List<QuestionAnwerList> questionAnwerList;

  SubmitQuizRequest({
    required this.quizId,
    required this.studentId,
    required this.questionAnwerList,
  });

  factory SubmitQuizRequest.fromJson(Map<String, dynamic> json) =>
      SubmitQuizRequest(
        quizId: json["quizId"],
        studentId: json["studentId"],
        questionAnwerList: List<QuestionAnwerList>.from(
            json["questionAnwerList"]
                .map((x) => QuestionAnwerList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "quizId": quizId,
        "studentId": studentId,
        "questionAnwerList":
            List<dynamic>.from(questionAnwerList.map((x) => x.toJson())),
      };
}

class QuestionAnwerList {
  int questionId;
  int answerId;

  QuestionAnwerList({
    required this.questionId,
    required this.answerId,
  });

  factory QuestionAnwerList.fromJson(Map<String, dynamic> json) =>
      QuestionAnwerList(
        questionId: json["questionId"],
        answerId: json["answerId"],
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "answerId": answerId,
      };
}
