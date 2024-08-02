import 'package:flutter/material.dart';
import 'package:my_web_app/page/admin_login_page.dart';
import 'package:my_web_app/page/admin_home_page.dart';
import 'package:my_web_app/page/admin_management.dart';
import 'package:my_web_app/page/admin_register_page.dart';
import 'package:my_web_app/page/export_page.dart';
import 'package:my_web_app/page/home_page.dart';
import 'package:my_web_app/page/login_page.dart';
import 'package:my_web_app/page/register_page.dart';
import 'package:my_web_app/page/user_management.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Web App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: HomePage(),
      
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/admin_login': (context) => AdminLoginPage(),
        '/admin_home': (context) => AdminHomePage(),
        '/admin_register': (context) => AdminRegisterPage(),
        '/user_management': (context) => UserManagement(),
        '/admin_management': (context) => AdminManagement(),
        '/export': (context) => ExportFilePage(),
      },

    );
  }
}




