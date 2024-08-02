import 'package:flutter/material.dart';

// Custom Status Row Widget
class StatusRow extends StatelessWidget {
  final String status;
  final ValueChanged<bool?> onChanged;

  StatusRow({
    required this.status,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Status:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[900],
          ),
        ),
        SizedBox(width: 10),
        Checkbox(
          value: status == 'true',
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
          checkColor: Colors.white,
          side: BorderSide(color: Colors.black),
        ),
      ],
    );
  }
}

