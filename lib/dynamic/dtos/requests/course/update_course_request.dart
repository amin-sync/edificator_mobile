import 'dart:convert';

UpdateCourseRequest updateCourseRequestFromJson(String str) =>
    UpdateCourseRequest.fromJson(json.decode(str));

String updateCourseRequestToJson(UpdateCourseRequest data) =>
    json.encode(data.toJson());

class UpdateCourseRequest {
  int courseId;
  String grade;
  String subject;
  String days;
  String fromTime;
  String toTime;
  String fee;

  UpdateCourseRequest({
    required this.courseId,
    required this.grade,
    required this.subject,
    required this.days,
    required this.fromTime,
    required this.toTime,
    required this.fee,
  });

  factory UpdateCourseRequest.fromJson(Map<String, dynamic> json) =>
      UpdateCourseRequest(
        courseId: json["courseId"],
        grade: json["grade"],
        subject: json["subject"],
        days: json["days"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        fee: json["fee"],
      );

  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "grade": grade,
        "subject": subject,
        "days": days,
        "fromTime": fromTime,
        "toTime": toTime,
        "fee": fee,
      };
}
