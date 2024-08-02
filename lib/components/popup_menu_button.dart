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
        return menuItems.map((PopupMenuEntry<String> entry) {
          if (entry is PopupMenuItem<String>) {
            return PopupMenuItem<String>(
              value: entry.value,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: entry.child, // แสดงเนื้อหาจริงจาก PopupMenuItem
              ),
            );
          }
          return entry;
        }).toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.black, // สีพื้นหลังของปุ่ม
          borderRadius: BorderRadius.circular(8.0), // มุมโค้ง
          boxShadow: [
            BoxShadow(
              color: Colors.purple,
              blurRadius: 10.0,
              offset: Offset(6, 6), // เงา
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 15.0),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
