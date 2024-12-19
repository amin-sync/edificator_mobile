import 'dart:convert';

CourseListByGradeResponse courseListByGradeResponseFromJson(String str) =>
    CourseListByGradeResponse.fromJson(json.decode(str));

String courseListByGradeResponseToJson(CourseListByGradeResponse data) =>
    json.encode(data.toJson());

class CourseListByGradeResponse {
  int id;
  String? profileUrl;
  String subject;
  String teacherName;

  CourseListByGradeResponse({
    required this.profileUrl,
    required this.subject,
    required this.teacherName,
    required this.id,
  });

  factory CourseListByGradeResponse.fromJson(Map<String, dynamic> json) =>
      CourseListByGradeResponse(
        profileUrl: json["profileUrl"],
        subject: json["subject"],
        teacherName: json["teacherName"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "profileUrl": profileUrl,
        "subject": subject,
        "teacherName": teacherName,
        "id": id,
      };
}
