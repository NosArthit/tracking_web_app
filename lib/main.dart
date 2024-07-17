import 'package:flutter/material.dart';
import 'package:my_web_app/home_page.dart';
import 'package:my_web_app/login_page.dart';
import 'package:my_web_app/recover_page.dart';
import 'package:my_web_app/register_page.dart';
import 'package:my_web_app/testlayout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GRB Tracking System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LayOutResPage(), 
        '/homeuser': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/recover': (context) => RecoverPage(),
      },
    );
  }
}

















