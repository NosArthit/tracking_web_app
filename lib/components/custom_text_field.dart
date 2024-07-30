import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final FormFieldSetter<String>? onSaved; // เปลี่ยนประเภทเป็น FormFieldSetter<String>?
  final bool obscureText;

  CustomTextField({
    required this.label,
    this.onSaved,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        obscureText: obscureText,
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}

