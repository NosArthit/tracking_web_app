import 'package:flutter/material.dart';

class CustomTextFieldAdminApproval extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color fillColor;
  final Color borderColor;
  final Color hintTextColor;
  final Color iconColor;

  CustomTextFieldAdminApproval({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.fillColor = Colors.amberAccent,
    this.borderColor = Colors.deepOrange,
    this.hintTextColor = Colors.black54,
    this.iconColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintTextColor),
          contentPadding:
              EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
          prefixIcon: Icon(icon, color: iconColor),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 4),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
