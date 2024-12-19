import 'dart:convert';

TeacherQuizListResponse quizResponseFromJson(String str) =>
    TeacherQuizListResponse.fromJson(json.decode(str));

String quizResponseToJson(TeacherQuizListResponse data) =>
    json.encode(data.toJson());

class TeacherQuizListResponse {
  int id;
  String title;
  String duration;

  TeacherQuizListResponse({
    required this.id,
    required this.title,
    required this.duration,
  });

  factory TeacherQuizListResponse.fromJson(Map<String, dynamic> json) =>
      TeacherQuizListResponse(
        id: json["id"],
        title: json["title"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "duration": duration,
      };
}
