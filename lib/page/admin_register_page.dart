import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:my_web_app/service/adminapi_service.dart';


class AdminRegisterPage extends StatefulWidget {
  @override
  _AdminRegisterPageState createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  final AdminApiService _apiService = AdminApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'email': _emailController.text,
      };

      final responseMessage = await _apiService.register(userData as String);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(responseMessage == 'User registered successfully'
                ? 'Registration Successful'
                : 'Registration Failed'),
            content: Text(responseMessage!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (responseMessage == 'User registered successfully') {
                    Navigator.pushReplacementNamed(context, '/admin_login');
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text('Register'),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
            
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your email';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Email pattern invalid';
                      }
                      return null;
                    },
                ),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    
                    onPressed: _register,
                    child: Text('Register', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin_login');
                  },
                  child: Text('Already have an admin account? Login', style: TextStyle(color: Colors.blue[600],)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}