import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../commons/toast.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool checkInternet;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue, // Default background color
    this.textColor = Colors.white, // Default text color
    this.fontSize = 14.0,
    this.checkInternet = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!checkInternet || await InternetConnectionChecker().hasConnection) {
          onPressed();
        } else {
          CustomToast.showDangerToast("No internet connected");
        }
      },
      style: ElevatedButton.styleFrom(
        primary: backgroundColor, // Background color for filled button
        padding: EdgeInsets.symmetric(vertical: 15), // Increase height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13), // More curved edges
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor, // Button text color
          fontSize: fontSize, // Custom font size
        ),
      ),
    );
  }
}
