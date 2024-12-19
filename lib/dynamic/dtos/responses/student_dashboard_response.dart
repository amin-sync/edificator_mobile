import 'dart:convert';

StudentDashboardResponse studentDashboardResponseFromJson(String str) => StudentDashboardResponse.fromJson(json.decode(str));

String studentDashboardResponseToJson(StudentDashboardResponse data) => json.encode(data.toJson());

class StudentDashboardResponse {
    String fullName;
    int assignmentCount;
    int quizCount;

    StudentDashboardResponse({
        required this.fullName,
        required this.assignmentCount,
        required this.quizCount,
    });

    factory StudentDashboardResponse.fromJson(Map<String, dynamic> json) => StudentDashboardResponse(
        fullName: json["fullName"],
        assignmentCount: json["assignmentCount"],
        quizCount: json["quizCount"],
    );

    Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "assignmentCount": assignmentCount,
        "quizCount": quizCount,
    };
}
