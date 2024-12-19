import 'dart:convert';

TeacherRegisterRequest teacherRegisterRequestFromJson(String str) =>
    TeacherRegisterRequest.fromJson(json.decode(str));

String teacherRegisterRequestToJson(TeacherRegisterRequest data) =>
    json.encode(data.toJson());

class TeacherRegisterRequest {
  String email;
  String fullName;
  String nic;
  String password;
  int roleId;
  String expertise;

  TeacherRegisterRequest({
    required this.email,
    required this.fullName,
    required this.nic,
    required this.password,
    required this.roleId,
    required this.expertise,
  });

  factory TeacherRegisterRequest.fromJson(Map<String, dynamic> json) =>
      TeacherRegisterRequest(
        email: json["email"],
        fullName: json["fullName"],
        nic: json["nic"],
        password: json["password"],
        roleId: json["roleId"],
        expertise: json["expertise"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "fullName": fullName,
        "nic": nic,
        "password": password,
        "roleId": roleId,
        "expertise": expertise,
      };
}
