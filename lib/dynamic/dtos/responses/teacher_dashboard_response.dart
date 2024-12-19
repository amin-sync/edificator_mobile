// To parse this JSON data, do
//
//     final teacherDashboardResponse = teacherDashboardResponseFromJson(jsonString);

import 'dart:convert';

TeacherDashboardResponse teacherDashboardResponseFromJson(String str) =>
    TeacherDashboardResponse.fromJson(json.decode(str));

String teacherDashboardResponseToJson(TeacherDashboardResponse data) =>
    json.encode(data.toJson());

class TeacherDashboardResponse {
  int courseCount;
  int enrolledStudentCount;
  String fullName;

  TeacherDashboardResponse({
    required this.courseCount,
    required this.enrolledStudentCount,
    required this.fullName,
  });

  factory TeacherDashboardResponse.fromJson(Map<String, dynamic> json) =>
      TeacherDashboardResponse(
        courseCount: json["courseCount"],
        enrolledStudentCount: json["enrolledStudentCount"],
        fullName: json["fullName"],
      );

  Map<String, dynamic> toJson() => {
        "courseCount": courseCount,
        "enrolledStudentCount": enrolledStudentCount,
        "fullName": fullName,
      };
}
