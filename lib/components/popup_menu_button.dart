import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final String title;
  final List<PopupMenuEntry<String>> menuItems;
  final void Function(String value) onSelected;

  const CustomPopupMenuButton({
    Key? key,
    required this.title,
    required this.menuItems,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return menuItems;
      },
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }
}

