import 'dart:convert';

GenericResponse genericResponseFromJson(String str) =>
    GenericResponse.fromJson(json.decode(str));

String genericResponseToJson(GenericResponse data) =>
    json.encode(data.toJson());

class GenericResponse {
  bool success;
  String? successMessage;
  String? errorMessage;
  int status;
  dynamic data;

  GenericResponse({
    required this.success,
    required this.successMessage,
    required this.errorMessage,
    required this.status,
    required this.data,
  });

  static Map<String, dynamic> getData(GenericResponse response) =>
      response.toJson()["data"];

  static List<dynamic> getListData(GenericResponse response) =>
      response.toJson()["data"];

  static GenericResponse getFailureResponse() => GenericResponse(
      status: 500,
      success: false,
      successMessage: "",
      errorMessage: "",
      data: null);

  static GenericResponse getSuccessResponse() => GenericResponse(
      status: 200,
      success: true,
      successMessage: "",
      errorMessage: "",
      data: null);

  factory GenericResponse.fromJson(Map<String, dynamic> json) =>
      GenericResponse(
          success: json["success"],
          successMessage: json["successMessage"],
          errorMessage: json["errorMessage"],
          status: json["status"],
          data: json["data"]);

  Map<String, dynamic> toJson() => {
        "success": success,
        "successMessage": successMessage,
        "errorMessage": errorMessage,
        "status": status,
        "data": data,
      };
}
