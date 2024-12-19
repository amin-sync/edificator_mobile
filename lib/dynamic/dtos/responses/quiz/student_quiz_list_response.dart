import 'dart:convert';

StudentQuizListResponse studentQuizListResponseFromJson(String str) =>
    StudentQuizListResponse.fromJson(json.decode(str));

String studentQuizListResponseToJson(StudentQuizListResponse data) =>
    json.encode(data.toJson());

class StudentQuizListResponse {
  String title;
  String duration;
  String status;
  String marks;
  String outOf;
  int id;

  StudentQuizListResponse({
    required this.title,
    required this.duration,
    required this.status,
    required this.marks,
    required this.id,
    required this.outOf,
  });

  factory StudentQuizListResponse.fromJson(Map<String, dynamic> json) =>
      StudentQuizListResponse(
        title: json["title"],
        duration: json["duration"],
        status: json["status"],
        marks: json["marks"],
        id: json["id"],
        outOf: json["outOf"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "duration": duration,
        "status": status,
        "marks": marks,
        "id": id,
        "outOf": outOf,
      };
}
