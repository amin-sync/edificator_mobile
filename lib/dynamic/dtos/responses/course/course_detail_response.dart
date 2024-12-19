import 'dart:convert';

CourseDetailResponse courseDetailResponseFromJson(String str) => CourseDetailResponse.fromJson(json.decode(str));

String courseDetailResponseToJson(CourseDetailResponse data) => json.encode(data.toJson());

class CourseDetailResponse {
    String fullName;
    String? profileUrl;
    String subject;
    String grade;
    String days;
    String fromTime;
    String toTime;
    String fee;
    String expertise;

    CourseDetailResponse({
        required this.fullName,
        required this.profileUrl,
        required this.subject,
        required this.grade,
        required this.days,
        required this.fromTime,
        required this.toTime,
        required this.fee,
        required this.expertise,
    });

    factory CourseDetailResponse.fromJson(Map<String, dynamic> json) => CourseDetailResponse(
        fullName: json["fullName"],
        profileUrl: json["profileUrl"],
        subject: json["subject"],
        grade: json["grade"],
        days: json["days"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        fee: json["fee"],
        expertise: json["expertise"],
    );

    Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "profileUrl": profileUrl,
        "subject": subject,
        "grade": grade,
        "days": days,
        "fromTime": fromTime,
        "toTime": toTime,
        "fee": fee,
        "expertise": expertise,
    };
}
