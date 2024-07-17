

//register page
import 'package:flutter/material.dart';
import 'package:my_web_app/api_service.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiService _apiService = ApiService();
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final response = await _apiService.register({
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
    });

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (Route<dynamic> route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  validator: (value) => value!.isEmpty ? 'Enter your phone number' : null,
                ),
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
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        child: Text('Register'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



