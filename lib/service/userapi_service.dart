import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApiService {
  static const String _baseUrl = 'http://localhost:3000/api/users';

  Future<String?> register(Map<String, String> userData) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return 'User registered successfully';
    } else {
      return 'Registration failed';
    }
  }

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'];

      // Decode JWT token to get expiration time
      final payload = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))));
      final exp = payload['exp'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('token_expiration', exp);

      return token;
    } else if (response.statusCode == 401) {
      final body = jsonDecode(response.body);
      return Future.error(body['message']);
    } else {
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); 
    if (token != null) {
      await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
      );
      await prefs.remove('token');
      await prefs.remove('token_expiration');
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String token) async {
    final url = Uri.parse('$_baseUrl/data');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 403) {
      // JWT expired or invalid, perform logout
      await logout();
      return null;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllUsers(String token) async {
    final url = Uri.parse('$_baseUrl/datas');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      return responseBody.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 403) {
      // JWT expired or invalid, perform logout
      await logout();
      return null;
    } else {
      return null;
    }
  }

  Future<void> updateUserDetails(Map<String, String> userData, String token) async {
    final url = Uri.parse('$_baseUrl/update');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user details');
    }
  }

  // Check if token is expired
  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final exp = prefs.getInt('token_expiration');
    if (exp != null) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return exp < now;
    }
    return true;
  }

  // Get remaining time of JWT in seconds
  Future<int?> getRemainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    final exp = prefs.getInt('token_expiration');
    if (exp != null) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final remainingTime = exp - now;
      return remainingTime > 0 ? remainingTime : 0;
    }
    return null;
  }
}






