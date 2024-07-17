

//login page
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_web_app/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StreamController<bool> _authStreamController = StreamController<bool>();

  @override
  void dispose() {
    _authStreamController.close();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await _apiService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (response.statusCode == 200) {
      _authStreamController.add(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      ); // ส่งค่า true ไปยัง Stream เมื่อ Login สำเร็จ
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter your email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Enter your password' : null,
              ),
              SizedBox(height: 20),
              StreamBuilder<bool>(
                stream: _authStreamController.stream,
                initialData: false,
                builder: (context, snapshot) {
                  return snapshot.data == true
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          child: Text('Login'),
                        );
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






