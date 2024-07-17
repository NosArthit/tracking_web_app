
//recovery page
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RecoverPage extends StatefulWidget {
  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoverPage> {
  final _formKey = GlobalKey<FormState>();
  String emailOrPhone = '';

  Future<void> recover() async {
    final response = await http.post(
      Uri.parse('http://<your-server-ip>:3000/api/customers/recover'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': emailOrPhone,
      }),
    );

    if (response.statusCode == 200) {
      // Handle recovery success, e.g., show a success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Recovery'),
            content: Text('Your password has been sent to your email.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Handle error
      print('Failed to recover password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Password Recovery')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email or Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email or phone';
                  }
                  return null;
                },
                onChanged: (value) {
                  emailOrPhone = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    recover();
                  }
                },
                child: Text('Recover Password'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


