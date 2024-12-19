import 'dart:convert';

EnrolledCoursesResponse enrolledCoursesResponseFromJson(String str) =>
    EnrolledCoursesResponse.fromJson(json.decode(str));

String enrolledCoursesResponseToJson(EnrolledCoursesResponse data) =>
    json.encode(data.toJson());

class EnrolledCoursesResponse {
  int courseId;
  String subject;
  String? profileUrl;
  String name;

  EnrolledCoursesResponse({
    required this.courseId,
    required this.subject,
    required this.profileUrl,
    required this.name,
  });

  factory EnrolledCoursesResponse.fromJson(Map<String, dynamic> json) =>
      EnrolledCoursesResponse(
        courseId: json["courseId"],
        subject: json["subject"],
        profileUrl: json["profileUrl"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "subject": subject,
        "profileUrl": profileUrl,
        "name": name,
      };
}
