import 'dart:convert';

TeacherCourseListResponse teacherCourseListResponseFromJson(String str) =>
    TeacherCourseListResponse.fromJson(json.decode(str));

String teacherCourseListResponseToJson(TeacherCourseListResponse data) =>
    json.encode(data.toJson());

class TeacherCourseListResponse {
  String subject;
  String grade;
  String fee;
  int id;
  String days;
  String fromTime;
  String toTime;

  TeacherCourseListResponse({
    required this.subject,
    required this.grade,
    required this.fee,
    required this.id,
    required this.days,
    required this.fromTime,
    required this.toTime,
  });

  factory TeacherCourseListResponse.fromJson(Map<String, dynamic> json) =>
      TeacherCourseListResponse(
        subject: json["subject"],
        grade: json["grade"],
        fee: json["fee"],
        id: json["id"],
        days: json["days"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "grade": grade,
        "fee": fee,
        "id": id,
        "days": days,
        "fromTime": fromTime,
        "toTime": toTime,
      };
}
