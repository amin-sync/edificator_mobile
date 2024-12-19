import 'dart:convert';

CreateAssignmentRequest createAssignmentRequestFromJson(String str) =>
    CreateAssignmentRequest.fromJson(json.decode(str));

String createAssignmentRequestToJson(CreateAssignmentRequest data) =>
    json.encode(data.toJson());

class CreateAssignmentRequest {
  String title;
  String courseId;
  String dueDate;

  CreateAssignmentRequest({
    required this.title,
    required this.courseId,
    required this.dueDate,
  });

  factory CreateAssignmentRequest.fromJson(Map<String, dynamic> json) =>
      CreateAssignmentRequest(
        title: json["title"],
        courseId: json["courseId"],
        dueDate: json["dueDate"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "courseId": courseId,
        "dueDate": dueDate,
      };
}
