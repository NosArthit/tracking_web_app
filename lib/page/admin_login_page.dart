//admin_login_page.dart
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_web_app/service/adminapi_service.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final AdminApiService _apiService = AdminApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adminIdController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final token = await _apiService.login(_emailController.text, _passwordController.text, _adminIdController.text);

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('email', _emailController.text);
          await prefs.setString('admin_id', _adminIdController.text);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Successful'),
              duration: Duration(seconds: 2),
            ),
          );

          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(context, '/admin_home');
          });
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_off,
                    size: 100,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Welcome Admin Mode",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Email pattern invalid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Password'),
                          obscureText: true,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your password' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _adminIdController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Admin ID'),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your Admin ID' : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/admin_register');
                    },
                    child: Text('Don\'t have an admin account? Register',
                      style: TextStyle(color: Colors.blue[600]),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

