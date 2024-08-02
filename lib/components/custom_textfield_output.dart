import 'package:flutter/material.dart';

class CustomTextFieldOutput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color fillColor;
  final Color borderColor;
  final Color hintTextColor;
  final Color iconColor;
  final bool enable;

  CustomTextFieldOutput({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.fillColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFF311B92),
    this.hintTextColor = const Color(0xFF311B92),
    this.iconColor = const Color(0xFF311B92),
    required this.enable
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabled: enable,
          hintText: hintText,
          hintStyle: TextStyle(color: hintTextColor),
          contentPadding:
              EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
          prefixIcon: Icon(icon, color: iconColor),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 4),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
