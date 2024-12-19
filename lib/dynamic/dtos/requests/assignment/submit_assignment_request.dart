import 'dart:convert';

SubmitAssignmentRequest submitAssignmentRequestFromJson(String str) =>
    SubmitAssignmentRequest.fromJson(json.decode(str));

String submitAssignmentRequestToJson(SubmitAssignmentRequest data) =>
    json.encode(data.toJson());

class SubmitAssignmentRequest {
  String assignmentId;
  String studentId;

  SubmitAssignmentRequest({
    required this.assignmentId,
    required this.studentId,
  });

  factory SubmitAssignmentRequest.fromJson(Map<String, dynamic> json) =>
      SubmitAssignmentRequest(
        assignmentId: json["assignmentId"],
        studentId: json["studentId"],
      );

  Map<String, dynamic> toJson() => {
        "assignmentId": assignmentId,
        "studentId": studentId,
      };
}
