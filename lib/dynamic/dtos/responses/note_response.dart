import 'dart:convert';

NoteResponse noteResponseFromJson(String str) => NoteResponse.fromJson(json.decode(str));

String noteResponseToJson(NoteResponse data) => json.encode(data.toJson());

class NoteResponse {
    int id;
    String title;
    DateTime createdOn;
    String fileName;

    NoteResponse({
        required this.id,
        required this.title,
        required this.createdOn,
        required this.fileName,
    });

    factory NoteResponse.fromJson(Map<String, dynamic> json) => NoteResponse(
        id: json["id"],
        title: json["title"],
        createdOn: DateTime.parse(json["createdOn"]),
        fileName: json["fileName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "createdOn": createdOn.toIso8601String(),
        "fileName": fileName,
    };
}