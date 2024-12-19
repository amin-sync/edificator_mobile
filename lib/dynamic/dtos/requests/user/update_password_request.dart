// To parse this JSON data, do
//
//     final updatePasswordRequest = updatePasswordRequestFromJson(jsonString);

import 'dart:convert';

UpdatePasswordRequest updatePasswordRequestFromJson(String str) => UpdatePasswordRequest.fromJson(json.decode(str));

String updatePasswordRequestToJson(UpdatePasswordRequest data) => json.encode(data.toJson());

class UpdatePasswordRequest {
    int userId;
    String newPassword;
    String oldPassword;

    UpdatePasswordRequest({
        required this.userId,
        required this.newPassword,
        required this.oldPassword,
    });

    factory UpdatePasswordRequest.fromJson(Map<String, dynamic> json) => UpdatePasswordRequest(
        userId: json["userId"],
        newPassword: json["newPassword"],
        oldPassword: json["oldPassword"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "newPassword": newPassword,
        "oldPassword": oldPassword,
    };
}
