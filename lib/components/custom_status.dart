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
      children: [
        Text('Status:'),
        Checkbox(
          value: status == 'true',
          onChanged: onChanged,
        ),
      ],
    );
  }
}
