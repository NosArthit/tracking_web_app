
// api service
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000/api/customers'; // เปลี่ยน URL ตาม API ของคุณ

  Future<http.Response> register(Map<String, String> formData) async {
    final url = Uri.parse('$baseUrl/register');
    return await http.post(url, body: json.encode(formData), headers: {'Content-Type': 'application/json'});
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final responseBody = json.decode(response.body);
      await prefs.setString('token', responseBody['token']);
      await prefs.setString('customer_id', responseBody['customer_id']);
      await prefs.setString('firstname', responseBody['firstname']);
      await prefs.setString('lastname', responseBody['lastname']);
    }

    return response;
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }

  Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'customer_id': prefs.getString('customer_id'),
      'firstname': prefs.getString('firstname'),
      'lastname': prefs.getString('lastname'),
    };
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('customer_id');
    await prefs.remove('firstname');
    await prefs.remove('lastname');
  }

  Future<http.Response> recover(Map<String, String> formData) async {
    final url = Uri.parse('$baseUrl/recover');
    return await http.post(url, body: json.encode(formData), headers: {'Content-Type': 'application/json'});
  }
}







