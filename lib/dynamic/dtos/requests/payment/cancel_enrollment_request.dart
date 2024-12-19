import 'dart:convert';

CancelEnrollmentRequest cancelEnrollmentRequestFromJson(String str) =>
    CancelEnrollmentRequest.fromJson(json.decode(str));

String cancelEnrollmentRequestToJson(CancelEnrollmentRequest data) =>
    json.encode(data.toJson());

class CancelEnrollmentRequest {
  int studentId;
  int courseId;

  CancelEnrollmentRequest({
    required this.studentId,
    required this.courseId,
  });

  factory CancelEnrollmentRequest.fromJson(Map<String, dynamic> json) =>
      CancelEnrollmentRequest(
        studentId: json["studentId"],
        courseId: json["courseId"],
      );

  Map<String, dynamic> toJson() => {
        "studentId": studentId,
        "courseId": courseId,
      };
}
