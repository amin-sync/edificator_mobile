import 'dart:convert';

UserProfileResponse userProfileResponseFromJson(String str) =>
    UserProfileResponse.fromJson(json.decode(str));

String userProfileResponseToJson(UserProfileResponse data) =>
    json.encode(data.toJson());

class UserProfileResponse {
  String email;
  String fullName;
  String? profileUrl;

  UserProfileResponse({
    required this.email,
    required this.fullName,
    required this.profileUrl,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      UserProfileResponse(
        email: json["email"],
        fullName: json["fullName"],
        profileUrl: json["profileURL"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "fullName": fullName,
        "profileURL": profileUrl,
      };
}
