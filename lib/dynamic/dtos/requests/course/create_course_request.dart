// To parse this JSON data, do
//
//     final createCourseRequest = createCourseRequestFromJson(jsonString);

import 'dart:convert';

CreateCourseRequest createCourseRequestFromJson(String str) =>
    CreateCourseRequest.fromJson(json.decode(str));

String createCourseRequestToJson(CreateCourseRequest data) =>
    json.encode(data.toJson());

class CreateCourseRequest {
  String grade;
  String subject;
  String days;
  String fromTime;
  String toTime;
  String fee;
  int teacherId;

  CreateCourseRequest({
    required this.grade,
    required this.subject,
    required this.days,
    required this.fromTime,
    required this.toTime,
    required this.fee,
    required this.teacherId,
  });

  factory CreateCourseRequest.fromJson(Map<String, dynamic> json) =>
      CreateCourseRequest(
        grade: json["grade"],
        subject: json["subject"],
        days: json["days"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        fee: json["fee"],
        teacherId: json["teacherId"],
      );

  Map<String, dynamic> toJson() => {
        "grade": grade,
        "subject": subject,
        "days": days,
        "fromTime": fromTime,
        "toTime": toTime,
        "fee": fee,
        "teacherId": teacherId,
      };
}
