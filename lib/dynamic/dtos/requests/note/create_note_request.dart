import 'dart:convert';

CreateNoteRequest createNoteRequestFromJson(String str) => CreateNoteRequest.fromJson(json.decode(str));

String createNoteRequestToJson(CreateNoteRequest data) => json.encode(data.toJson());

class CreateNoteRequest {
    String title;
    String courseId;

    CreateNoteRequest({
        required this.title,
        required this.courseId,
    });

    factory CreateNoteRequest.fromJson(Map<String, dynamic> json) => CreateNoteRequest(
        title: json["title"],
        courseId: json["courseId"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "courseId": courseId,
    };
}