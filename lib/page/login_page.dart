import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:my_web_app/components/signInBtn.dart';
import 'package:my_web_app/components/squaretile.dart';
import 'package:my_web_app/page/register_page.dart';
import 'package:my_web_app/service/userapi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserApiService _apiService = UserApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final token = await _apiService.login(
            _emailController.text, _passwordController.text);

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Successful'),
              duration: Duration(seconds: 2),
            ),
          );

          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(context, '/home');
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
        padding: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //logo
                  const Icon(
                    Icons.lock_person,
                    size: 70,
                  ),
            
                  const SizedBox(height: 15),
                  Text(
                    "Welcome back again!",
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
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return RegisterPage();
                              }));
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.blue[600]),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
            
                  SignInBtn(onTap: _login),
            
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Don\'t have an account? Register', style: TextStyle(color: Colors.blue[600]),),
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/admin_login');
                    },
                    child: Text('Sign In in admin mode', style: TextStyle(color: Colors.blue[600]),),
                  ),
                  const SizedBox(height: 25),
            
                  // Or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Row(children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ))
                    ]),
                  ),
            
                  const SizedBox(height: 25),
            
                  // Google, Facebook button
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                          imagePath:
                              '/Users/arthitkhongsukhee/tracking_web_app/assets/images/google-logo.png'),
                      SizedBox(
                        width: 50,
                      ),
                      SquareTile(
                          imagePath:
                              '/Users/arthitkhongsukhee/tracking_web_app/assets/images/facebook-logo.jpg'),
                    ],
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
