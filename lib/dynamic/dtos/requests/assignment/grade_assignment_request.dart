import 'dart:convert';

GradeAssignmentRequest gradeAssignmentRequestFromJson(String str) =>
    GradeAssignmentRequest.fromJson(json.decode(str));

String gradeAssignmentRequestToJson(GradeAssignmentRequest data) =>
    json.encode(data.toJson());

class GradeAssignmentRequest {
  int assignmentId;
  int studentId;
  String marks;

  GradeAssignmentRequest({
    required this.assignmentId,
    required this.studentId,
    required this.marks,
  });

  factory GradeAssignmentRequest.fromJson(Map<String, dynamic> json) =>
      GradeAssignmentRequest(
        assignmentId: json["assignmentId"],
        studentId: json["studentId"],
        marks: json["marks"],
      );

  Map<String, dynamic> toJson() => {
        "assignmentId": assignmentId,
        "studentId": studentId,
        "marks": marks,
      };
}
