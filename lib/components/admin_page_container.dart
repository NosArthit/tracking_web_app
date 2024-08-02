import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_web_app/components/popup_menu_button.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ใช้สำหรับจัดการ JWT ใน shared preferences

class AdminPageContainer extends StatelessWidget {
  final String userEmail;
  final String userID;
  final VoidCallback onLogout;
  final int remainingTime;

  AdminPageContainer({
    required this.userEmail,
    required this.userID,
    required this.onLogout,
    required this.remainingTime,
  });

  Future<void> _logout(BuildContext context) async {
    // Delete JWT from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
  }

  @override
  Widget build(BuildContext context) {
    final hours = remainingTime ~/ 3600;
    final minutes = (remainingTime % 3600) ~/ 60;
    final seconds = remainingTime % 60;

    return Container(
      child: userEmail.isEmpty 
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                                           
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
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
                            children: [
                              SizedBox(width: 15,),
                              Text(
                                'Admin Account:   $userEmail' ,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 70,),
                              Text(
                                'Admin ID:    $userID' ,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
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
                              child: Text(
                                'Time remaining: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 15),
                            //Home nav bar
                            CustomPopupMenuButton(
                              title: 'Menu',
                              menuItems: const [
                                PopupMenuItem<String>(
                                  value: 'Home Management',
                                  child: Text('Home Management'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'User Management',
                                  child: Text('User Management'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Admin Management',
                                  child: Text('Admin Management'),
                                ),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 'Home Management':
                                    Navigator.pushNamed(
                                        context, '/admin_home');
                                    break;
                                  case 'User Management':
                                    Navigator.pushNamed(
                                        context, '/user_management');
                                    break;
                                  case 'Admin Management':
                                    Navigator.pushNamed(
                                        context, '/admin_management');
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
