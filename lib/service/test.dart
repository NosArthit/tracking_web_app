

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminApiService {
  static const String _baseUrl = 'http://localhost:3000/api/admin';
  final String baseUrl = 'http://localhost:3000/api/admin/user';

  Future<String?> register(String email) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 201) {
      return 'Admin registered successfully';
    } else {
      final body = jsonDecode(response.body);
      return Future.error(body['message']);
    }
  }

  Future<String?> login(String email, String password, String adminId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'admin_id': adminId,
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

  // Method for deleting a user
  Future<void> deleteUser(String email) async {

    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/user/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      print('User deleted successfully');
    } else {
      throw Exception('Failed to delete user');
    }
  }

  // Method for updating user status
  Future<void> updateUserStatus(String email, bool status, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/user/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({'email': email, 'status': status}),
    );

    if (response.statusCode == 200) {
      print('User status updated successfully');
    } else {
      throw Exception('Failed to update user status');
    }
  }

  // Method for updating admin status
  Future<void> updateAdminStatus(String email, bool status, String refEmail, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/admin/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({'email': email, 'status': status, 'ref_email': refEmail}),
    );

    if (response.statusCode == 200) {
      print('Admin status updated successfully');
    } else {
      throw Exception('Failed to update admin status');
    }
  }

  // Method for fetching user data
Future<List<dynamic>> fetchUserData({
    String date = '',
    String time = '',
    String userId = '',
    String firstname = '',
    String lastname = '',
    String company = '',
    String address = '',
    String city = '',
    String state = '',
    String country = '',
    String postalCode = '',
    String phone = '',
    required String email,
    required bool status,
    String dateInfoUpdate = '',
    String timeInfoUpdate = '',
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/fetch')
        .replace(queryParameters: {
          'date': date,
          'time': time,
          'user_id': userId,
          'firstname': firstname,
          'lastname': lastname,
          'company': company,
          'address': address,
          'city': city,
          'state': state,
          'country': country,
          'postal_code': postalCode,
          'phone': phone,
          'email': email,
          'status': status.toString(),
          'date_info_update': dateInfoUpdate,
          'time_info_update': timeInfoUpdate,
        });

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized request: ${response.body}');
    } else if (response.statusCode == 404) {
      throw Exception('Endpoint not found: ${response.body}');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.body}');
    } else {
      throw Exception('Failed to fetch user data: ${response.body}');
    }
  }

  Future<void> updateUser({
    required String userId,
    required String firstname,
    required String lastname,
    required String company,
    required String address,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    required String phone,
    required String email,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/update');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: json.encode({
        'user_id': userId,
        'firstname': firstname,
        'lastname': lastname,
        'company': company,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'postal_code': postalCode,
        'phone': phone,
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user data: ${response.body}');
    }
  }


  Future<List<dynamic>> fetchUserDetails({
    String? userId,
    String? email,
    required String token,
  }) async {
    // Construct the query parameters based on the input
    final queryParameters = {
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
    };

    final uri = Uri.parse('$_baseUrl/user/details').replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: Either user_id or email is required');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden: Admin not found or not authorized');
    } else if (response.statusCode == 404) {
      throw Exception('Not found: No user found matching the criteria');
    } else {
      throw Exception('Failed to fetch user details');
    }
  }
}








