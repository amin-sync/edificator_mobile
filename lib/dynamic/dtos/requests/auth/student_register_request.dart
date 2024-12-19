import 'dart:convert';

StudentRegisterRequest studentRegisterRequestFromJson(String str) =>
    StudentRegisterRequest.fromJson(json.decode(str));

String studentRegisterRequestToJson(StudentRegisterRequest data) =>
    json.encode(data.toJson());

class StudentRegisterRequest {
  String email;
  String fullName;
  String nic;
  String password;
  String grade;
  int roleId;

  StudentRegisterRequest({
    required this.email,
    required this.fullName,
    required this.nic,
    required this.password,
    required this.grade,
    required this.roleId,
  });

  factory StudentRegisterRequest.fromJson(Map<String, dynamic> json) =>
      StudentRegisterRequest(
        email: json["email"],
        fullName: json["fullName"],
        nic: json["nic"],
        password: json["password"],
        grade: json["grade"],
        roleId: json["roleId"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "fullName": fullName,
        "nic": nic,
        "password": password,
        "grade": grade,
        "roleId": roleId,
      };
}
