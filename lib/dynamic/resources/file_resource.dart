import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../commons/api_constants.dart';
import '../../commons/toast.dart';
import '../dtos/requests/download_file_request.dart';

class FileResource {
  Future<void> downloadFile(
      DownloadFileRequest request, BuildContext context) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/file/download"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      final Uint8List fileBytes = response.bodyBytes;
      final Directory? downloadsDir = Directory("/storage/emulated/0/Download");
      final String downloadsPath = downloadsDir!.path;
      final File file = File("$downloadsPath/${request.fileName}");
      await file.writeAsBytes(fileBytes);

      String? downloadedFilePath = file.path;
      // ignore: unnecessary_null_comparison
      if (downloadedFilePath != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File downloaded to: $downloadedFilePath")),
        );
      } else {
        CustomToast.showToast("Error downloading notes.");
      }
    }
  }
}
