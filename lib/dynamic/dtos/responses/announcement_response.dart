import 'dart:convert';

AnnouncementResponse announcementResponseFromJson(String str) => AnnouncementResponse.fromJson(json.decode(str));

String announcementResponseToJson(AnnouncementResponse data) => json.encode(data.toJson());

class AnnouncementResponse {
    String message;
    DateTime createdDate;

    AnnouncementResponse({
        required this.message,
        required this.createdDate,
    });

    factory AnnouncementResponse.fromJson(Map<String, dynamic> json) => AnnouncementResponse(
        message: json["message"],
        createdDate: DateTime.parse(json["createdDate"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "createdDate": createdDate.toIso8601String(),
    };
}