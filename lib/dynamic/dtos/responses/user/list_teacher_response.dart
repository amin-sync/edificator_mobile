import 'dart:convert';

ListTeacherResponse listTeacherResponseFromJson(String str) => ListTeacherResponse.fromJson(json.decode(str));

String listTeacherResponseToJson(ListTeacherResponse data) => json.encode(data.toJson());

class ListTeacherResponse {
    String? profileUrl;
    int id;
    String fullName;

    ListTeacherResponse({
        required this.profileUrl,
        required this.id,
        required this.fullName,
    });

    factory ListTeacherResponse.fromJson(Map<String, dynamic> json) => ListTeacherResponse(
        profileUrl: json["profileURL"],
        id: json["id"],
        fullName: json["fullName"],
    );

    Map<String, dynamic> toJson() => {
        "profileURL": profileUrl,
        "id": id,
        "fullName": fullName,
    };
}
