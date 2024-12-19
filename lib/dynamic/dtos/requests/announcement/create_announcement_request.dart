import 'dart:convert';

CreateAnnouncementRequest createAnnouncementRequestFromJson(String str) => CreateAnnouncementRequest.fromJson(json.decode(str));

String createAnnouncementRequestToJson(CreateAnnouncementRequest data) => json.encode(data.toJson());

class CreateAnnouncementRequest {
    String message;
    int courseId;

    CreateAnnouncementRequest({
        required this.message,
        required this.courseId,
    });

    factory CreateAnnouncementRequest.fromJson(Map<String, dynamic> json) => CreateAnnouncementRequest(
        message: json["message"],
        courseId: json["courseId"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "courseId": courseId,
    };
}