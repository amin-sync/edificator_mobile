import 'package:flutter/material.dart';
import '../texts/custom_text.dart'; // Adjust the path to your `CustomText` widget

class CustomStatusCard extends StatelessWidget {
  final String text; // The text to display in the card
  final Color backgroundColor; // Background color of the card
  final Color textColor; // Text color of the card

  const CustomStatusCard({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomText(
        text: text,
        fontSize: 14,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
