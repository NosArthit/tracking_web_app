//AdminApiService
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
      final payload = jsonDecode(utf8
          .decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))));
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

  static Future<void> logout({required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$_baseUrl/logout');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );
    await prefs.remove('token');
    await prefs.remove('token_expiration');
    if (response.statusCode == 200) {
      print('User deleted successfully');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete user');
    }
  }

  // Method for deleting an admin
Future<void> deleteUser({
    String? userId,
    String? email,
    required String token,
  }) async {
    if (userId == null && email == null) {
      throw Exception('Either userId or email must be provided');
    }

    final url = Uri.parse('$_baseUrl/admin/delete').replace(queryParameters: {
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
    });

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      print('User deleted successfully');
      return json.decode(response.body);
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete user');
    }
  }

  Future<void> deleteAdmin({
    String? userId,
    String? email,
    required String token,
  }) async {
    if (userId == null && email == null) {
      throw Exception('Either userId or email must be provided');
    }

    final url = Uri.parse('$baseUrl/delete').replace(queryParameters: {
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
    });

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      print('User deleted successfully');
      return json.decode(response.body);
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete user');
    }
  }


  // Method for updating user status
  Future<void> updateUserStatus(
      {String? userId,
      String? email,
      required String status,
      required String token}) async {
    final url = Uri.parse('$baseUrl/status').replace(queryParameters: {
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
    });
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      print('User status updated successfully');
      return;
    } else {
      throw Exception('Failed to update user status');
    }
  }

  // Method for updating admin status
  Future<void> updateAdminStatus(
      {String? userId,
      String? email,
      required String status,
      required String refEmail,
      required String token}) async {
    final url = Uri.parse('$_baseUrl/admin/status').replace(queryParameters: {
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
    });
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({'status': status, 'ref_email': refEmail}),
    );

    if (response.statusCode == 200) {
      print('User status updated successfully');
      return;
    } else {
      throw Exception('Failed to update user status');
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
    String email = '',
    String status = '',
    String dateInfoUpdate = '',
    String timeInfoUpdate = '',
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/fetch').replace(queryParameters: {
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
      'status': status,
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


  // Method for fetching admin data
  Future<List<dynamic>> fetchAdminData({
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
    String email = '',
    String status = '',
    String dateInfoUpdate = '',
    String timeInfoUpdate = '',
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/admin/fetch').replace(queryParameters: {
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
      'status': status,
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



////////////////
  Future<void> updateUser({
    String? userId,
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
    final url = Uri.parse('$baseUrl/update').replace(queryParameters: {
      'user_id': userId,
    });

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: json.encode({
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

    if (response.statusCode == 200) {
      //print('User data updated successfully');
      return;
    } else if (response.statusCode == 401) {
      //print('HTTP Error 401 Unauthorized: HTTP Error 401 Unauthorized');
      return;
    } else if (response.statusCode == 403) {
      //print('Forbidden: Admin not found or not authorized');
      return;
    } else if (response.statusCode == 404) {
      //print('Failed to update user data: User not found');
      return;
    } else if (response.statusCode >= 500) {
      //print('Failed to update user data: Internal Server Error');
      return;
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

    final uri = Uri.parse('$_baseUrl/user/details')
        .replace(queryParameters: queryParameters);

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
