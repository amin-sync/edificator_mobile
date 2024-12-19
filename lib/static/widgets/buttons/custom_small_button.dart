import 'package:flutter/material.dart';
import '../../widgets/texts/custom_text.dart'; // Assuming you have the CustomText widget in your project

class CustomSmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;

  CustomSmallButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue, // Default background color
    this.textColor = Colors.white, // Default text color
    this.fontSize = 13.0, // Custom font size
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor, // Background color for the small button
        padding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Button size
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Slightly curved edges
        ),
      ),
      child: CustomText(
        text: text,
        color: textColor, // Text color inside the button
        fontSize: fontSize, // Custom font size
      ),
    );
  }
}
