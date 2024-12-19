import 'dart:convert';

StudentQuizListRequest studentQuizListRequestFromJson(String str) =>
    StudentQuizListRequest.fromJson(json.decode(str));

String studentQuizListRequestToJson(StudentQuizListRequest data) =>
    json.encode(data.toJson());

class StudentQuizListRequest {
  int studentId;
  int courseId;

  StudentQuizListRequest({
    required this.studentId,
    required this.courseId,
  });

  factory StudentQuizListRequest.fromJson(Map<String, dynamic> json) =>
      StudentQuizListRequest(
        studentId: json["studentId"],
        courseId: json["courseId"],
      );

  Map<String, dynamic> toJson() => {
        "studentId": studentId,
        "courseId": courseId,
      };
}
