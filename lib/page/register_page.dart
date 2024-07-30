import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:my_web_app/service/userapi_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserApiService _apiService = UserApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'firstname': _firstnameController.text,
        'lastname': _lastnameController.text,
        'company': _companyController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'country': _countryController.text,
        'postal_code': _postalCodeController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      final responseMessage = await _apiService.register(userData);

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
                    Navigator.pushReplacementNamed(context, '/login');
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
                  controller: _firstnameController,
                  decoration: InputDecoration(labelText: 'Firstname'),
                  validator: (value) => value!.isEmpty ? 'Enter your firstname' : null,
                ),
                TextFormField(
                  controller: _lastnameController,
                  decoration: InputDecoration(labelText: 'Lastname'),
                  validator: (value) => value!.isEmpty ? 'Enter your lastname' : null,
                ),
                TextFormField(
                  controller: _companyController,
                  decoration: InputDecoration(labelText: 'Company'),
                  validator: (value) => value!.isEmpty ? 'Enter your company' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) => value!.isEmpty ? 'Enter your address' : null,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) => value!.isEmpty ? 'Enter your city' : null,
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(labelText: 'State'),
                  validator: (value) => value!.isEmpty ? 'Enter your state' : null,
                ),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                  validator: (value) => value!.isEmpty ? 'Enter your country' : null,
                ),
                TextFormField(
                  controller: _postalCodeController,
                  decoration: InputDecoration(labelText: 'Postal Code'),
                  validator: (value) => value!.isEmpty ? 'Enter your postal code' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) => value!.isEmpty ? 'Enter your phone' : null,
                ),
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
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Enter your password' : null,
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
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('Already have an account? Login', style: TextStyle(color: Colors.blue[600],)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




