import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../commons/colors.dart';

class CustomProfile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color textColor; // New parameter for text color

  const CustomProfile({
    required this.icon,
    required this.text,
    required this.onTap,
    this.textColor = Colors.black, // Default color is teal
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MyColor.tealColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 18, color: MyColor.tealColor),
        onTap: onTap,
      ),
    );
  }
}
