import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType inputType;
  final Color? suffixIconColor;
  final String? Function(String?)? validator; // Validator function added

  CustomField({
    required this.label,
    this.isPassword = false,
    this.controller,
    this.inputType = TextInputType.text,
    this.suffixIconColor,
    this.validator, // Accepting validator as a parameter
  });

  @override
  _CustomFieldState createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: MyColor.blueColor,
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscured : false,
      keyboardType: widget.inputType,
      validator: widget.validator, // Applying the validator function
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: MyColor.blueColor, fontSize: 14),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: MyColor.redColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColor.blueColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColor.blueColor),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: widget.suffixIconColor,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
        errorStyle: TextStyle(
          color: MyColor.redColor,
          fontSize: 12,
        ),
      ),
      style: TextStyle(color: MyColor.blackColor),
    );
  }
}
