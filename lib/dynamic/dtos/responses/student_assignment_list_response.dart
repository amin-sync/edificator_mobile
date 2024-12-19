import 'dart:convert';

StudentAssignmentListResponse studentAssignmentListResponseFromJson(
        String str) =>
    StudentAssignmentListResponse.fromJson(json.decode(str));

String studentAssignmentListResponseToJson(
        StudentAssignmentListResponse data) =>
    json.encode(data.toJson());

class StudentAssignmentListResponse {
  int id;
  String title;
  String dueDate;
  String status;
  String fileName;
  String marks;

  StudentAssignmentListResponse({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.status,
    required this.fileName,
    required this.marks,
  });

  factory StudentAssignmentListResponse.fromJson(Map<String, dynamic> json) =>
      StudentAssignmentListResponse(
        id: json["id"],
        title: json["title"],
        dueDate: json["dueDate"],
        status: json["status"],
        fileName: json["fileName"],
        marks: json["marks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "dueDate": dueDate,
        "status": status,
        "fileName": fileName,
        "marks": marks,
      };
}
