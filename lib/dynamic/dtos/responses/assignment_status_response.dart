import 'dart:convert';

AssignmentStatusResponse assignmentStatusResponseFromJson(String str) =>
    AssignmentStatusResponse.fromJson(json.decode(str));

String assignmentStatusResponseToJson(AssignmentStatusResponse data) =>
    json.encode(data.toJson());

class AssignmentStatusResponse {
  String fullName;
  String status;
  String? fileName;

  AssignmentStatusResponse({
    required this.fullName,
    required this.status,
    required this.fileName,
  });

  factory AssignmentStatusResponse.fromJson(Map<String, dynamic> json) =>
      AssignmentStatusResponse(
        fullName: json["fullName"],
        status: json["status"],
        fileName: json["fileName"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "status": status,
        "fileName": fileName,
      };
}
