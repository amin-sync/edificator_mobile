import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  int userId;
  int associateId;
  int roleId;
  bool login;

  LoginResponse({
    required this.userId,
    required this.associateId,
    required this.roleId,
    required this.login,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        userId: json["userId"],
        associateId: json["associateId"],
        roleId: json["roleId"],
        login: json["login"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "associateId": associateId,
        "roleId": roleId,
        "login": login,
      };
}
