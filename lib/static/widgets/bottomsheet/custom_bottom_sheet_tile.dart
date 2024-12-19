import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../commons/colors.dart';

class CustomBottomSheetTile extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color textColor;

  const CustomBottomSheetTile({
    required this.icon,
    required this.text,
    required this.onTap,
    this.textColor = Colors.black, // Default color is teal
  });

  @override
  State<CustomBottomSheetTile> createState() => _CustomBottomSheetTileState();
}

class _CustomBottomSheetTileState extends State<CustomBottomSheetTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MyColor.tealColor,
          child: Icon(widget.icon, color: Colors.white),
        ),
        title: Text(
          widget.text,
          style: TextStyle(color: widget.textColor),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 18, color: MyColor.tealColor),
        onTap: widget.onTap,
      ),
    );
  }
}
