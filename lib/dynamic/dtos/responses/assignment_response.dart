import 'dart:convert';

TeacherAssignmentListResponse assignmentResponseFromJson(String str) =>
    TeacherAssignmentListResponse.fromJson(json.decode(str));

String assignmentResponseToJson(TeacherAssignmentListResponse data) =>
    json.encode(data.toJson());

class TeacherAssignmentListResponse {
  String title;
  int id;
  String dueDate;

  TeacherAssignmentListResponse({
    required this.title,
    required this.id,
    required this.dueDate,
  });

  factory TeacherAssignmentListResponse.fromJson(Map<String, dynamic> json) =>
      TeacherAssignmentListResponse(
        title: json["title"],
        id: json["id"],
        dueDate: json["dueDate"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "id": id,
        "dueDate": dueDate,
      };
}
