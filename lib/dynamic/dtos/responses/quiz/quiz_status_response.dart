import 'dart:convert';

QuizStatusResponse quizStatusResponseFromJson(String str) =>
    QuizStatusResponse.fromJson(json.decode(str));

String quizStatusResponseToJson(QuizStatusResponse data) =>
    json.encode(data.toJson());

class QuizStatusResponse {
  String fullName;
  String marks;
  String status;
  String outOf;

  QuizStatusResponse({
    required this.fullName,
    required this.marks,
    required this.status,
    required this.outOf,
  });

  factory QuizStatusResponse.fromJson(Map<String, dynamic> json) =>
      QuizStatusResponse(
        fullName: json["fullName"],
        marks: json["marks"],
        status: json["status"],
        outOf: json["outOf"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "marks": marks,
        "status": status,
        "outOf": outOf,
      };
}
