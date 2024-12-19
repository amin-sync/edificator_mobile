import 'dart:convert';

StudentAssignmentListRequest studentAssignmentListRequestFromJson(String str) => StudentAssignmentListRequest.fromJson(json.decode(str));

String studentAssignmentListRequestToJson(StudentAssignmentListRequest data) => json.encode(data.toJson());

class StudentAssignmentListRequest {
    int studentId;
    int courseId;

    StudentAssignmentListRequest({
        required this.studentId,
        required this.courseId,
    });

    factory StudentAssignmentListRequest.fromJson(Map<String, dynamic> json) => StudentAssignmentListRequest(
        studentId: json["studentId"],
        courseId: json["courseId"],
    );

    Map<String, dynamic> toJson() => {
        "studentId": studentId,
        "courseId": courseId,
    };
}
