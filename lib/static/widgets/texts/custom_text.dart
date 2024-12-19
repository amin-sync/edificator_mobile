import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  CustomText({
    key,
    required this.text,
    required this.fontSize,
    required this.color,
    this.fontWeight = FontWeight.normal,
  });
  String text;
  double fontSize;
  Color color;
  FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ));
  }
}
