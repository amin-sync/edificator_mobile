import 'dart:io';
import 'dart:typed_data';
import 'package:edificators_hub_mobile/commons/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import 'colors.dart';

class Utility {
  // media type
  static MediaType getMediaTypeForFile(XFile file) {
    String? mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      throw Exception("Unsupported file type");
    }

    List<String> mimeParts = mimeType.split('/');
    String mimeTypeMain = mimeParts[0];
    String mimeTypeSub = mimeParts[1];
    return MediaType(mimeTypeMain, mimeTypeSub);
  }

  static String getFormattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  static Future<File> compressImage(File file) async {
    // Read the image as bytes
    Uint8List bytes = await file.readAsBytes();

    // Decode the image using the `image` package
    img.Image? decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) throw Exception("Failed to decode image");

    // Compress the image (adjust quality and dimensions if needed)
    img.Image resizedImage =
        img.copyResize(decodedImage, width: 800); // Example resize
    Uint8List compressedBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: 80)); // Adjust quality here

    // Save the compressed image to a temporary file
    Directory tempDir = await getTemporaryDirectory();
    File compressedFile = File('${tempDir.path}/compressed_image.jpg');
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  static String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      if (diff.inHours > 0) {
        time = diff.inHours.toString() + 'h';
      } else if (diff.inMinutes > 0) {
        time = diff.inMinutes.toString() + 'm';
      } else if (diff.inSeconds > 0) {
        time = 'now';
      } else if (diff.inMilliseconds > 0) {
        time = 'now';
      } else if (diff.inMicroseconds > 0) {
        time = 'now';
      } else {
        time = 'now';
      }
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      time = diff.inDays.toString() + 'd';
    } else if (diff.inDays > 6) {
      time = (diff.inDays / 7).floor().toString() + 'w';
    } else if (diff.inDays > 29) {
      time = (diff.inDays / 30).floor().toString() + 'm';
    } else if (diff.inDays > 365) {
      time = '${date.month} ${date.day}, ${date.year}';
    }
    return time;
  }

  static List<TextSpan> getTextWithLinks(String text) {
    final List<TextSpan> spans = [];
    final urlRegExp = RegExp(
      r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+',
    );

    final matches = urlRegExp.allMatches(text);
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Add the text before the URL as a normal TextSpan
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(color: MyColor.whiteColor, fontSize: 16),
        ));
      }

      // Add the URL as a clickable TextSpan
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(color: MyColor.whiteColor, fontSize: 16, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final url = text.substring(match.start, match.end);
            // Launch the URL
            Clipboard.setData(ClipboardData(text: url));
            CustomToast.showToast('Link copied to clipboard!');
          },
      ));
      lastMatchEnd = match.end;
    }

    // Add remaining text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(color: MyColor.whiteColor, fontSize: 16),
      ));
    }

    return spans;
  }
}
