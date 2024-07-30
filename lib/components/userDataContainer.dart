import 'package:flutter/material.dart';
import 'package:my_web_app/components/popup_menu_button.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ใช้สำหรับจัดการ JWT ใน shared preferences

class UserDataContainer extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback onLogout;
  final int remainingTime;

  UserDataContainer({
    required this.userData,
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
      child: userData == null
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
                        Text(
                          'Welcome, ${userData!['firstname']} ${userData!['lastname']} ID: ${userData!['user_id']} Company: ${userData!['company']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            //Home nav bar
                            CustomPopupMenuButton(
                              title: 'Home',
                              menuItems: [
                                PopupMenuItem<String>(
                                  value: 'Home',
                                  child: Text('Home'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Export File',
                                  child: Text('Export File'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Admin Mode',
                                  child: Text('Admin Mode'),
                                ),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 'Home':
                                    Navigator.pushNamed(context, '/home');
                                    break;
                                  case 'Export File':
                                    Navigator.pushNamed(context, '/export');
                                    break;
                                  case 'Admin Mode':
                                    Navigator.pushNamed(context, '/admin_login');
                                    break;
                                }
                              },
                            ),
                            SizedBox(width: 17,),
                            //About nav bar
                            CustomPopupMenuButton(
                              title: 'About',
                              menuItems: [
                                PopupMenuItem<String>(
                                  value: 'Profile',
                                  child: Text('Profile'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Login',
                                  child: Text('Login'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Register',
                                  child: Text('Register'),
                                ),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 'Profile':
                                    Navigator.pushNamed(context, '/profile');
                                    break;
                                  case 'Login':
                                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                                    _logout(context);
                                    break;
                                  case 'Register':
                                    Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false);
                                    _logout(context);
                                    break;
                                }
                              },
                            ),
                            SizedBox(width: 8,),
                            //Contact nav bar
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Contact',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Time remaining: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        _logout(context);
                      },
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ],
            ),
    );
  }
}

