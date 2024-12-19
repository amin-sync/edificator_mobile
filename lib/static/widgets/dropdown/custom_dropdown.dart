// custom_dropdown.dart

import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> options;
  final String label;
  final Function(String?) onChanged;

  final String? Function(String?)? validator;

  CustomDropdown({
    required this.value,
    required this.options,
    required this.label,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: MyColor.blueColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColor.blueColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColor.redColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColor.blueColor),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        filled: true,
        fillColor: Colors.white,
      ),
      value: value,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option, style: TextStyle(color: MyColor.blackColor)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
