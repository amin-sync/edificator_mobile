import 'dart:convert';

ListStudentsResponse listStudentsResponseFromJson(String str) =>
    ListStudentsResponse.fromJson(json.decode(str));

String listStudentsResponseToJson(ListStudentsResponse data) =>
    json.encode(data.toJson());

class ListStudentsResponse {
  String? profileUrl;
  int id;
  String fullName;

  ListStudentsResponse({
    required this.profileUrl,
    required this.id,
    required this.fullName,
  });

  factory ListStudentsResponse.fromJson(Map<String, dynamic> json) =>
      ListStudentsResponse(
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
