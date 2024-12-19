import 'dart:convert';

DownloadFileRequest downloadFileRequestFromJson(String str) =>
    DownloadFileRequest.fromJson(json.decode(str));

String downloadFileRequestToJson(DownloadFileRequest data) =>
    json.encode(data.toJson());

class DownloadFileRequest {
  String fileName;
  String type;

  DownloadFileRequest({
    required this.fileName,
    required this.type,
  });

  factory DownloadFileRequest.fromJson(Map<String, dynamic> json) =>
      DownloadFileRequest(
        fileName: json["fileName"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "type": type,
      };
}
