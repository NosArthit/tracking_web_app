

//home page
import 'package:flutter/material.dart';
import 'package:my_web_app/api_service.dart';

class HomePage extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _apiService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          final isAuthenticated = snapshot.data ?? false;
          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Center(
              child: isAuthenticated
                  ? FutureBuilder<Map<String, String?>>(
                      future: _apiService.getUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final userDetails = snapshot.data;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Welcome ${userDetails!['firstname']} ${userDetails['lastname']}'),
                              Text('Customer ID: ${userDetails['customer_id']}'),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  await _apiService.logout();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Logged out successfully')),
                                  );
                                  /*
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (Route<dynamic> route) => false,
                                  );
                                  */
                                },
                                child: Text('Logout'),
                              ),
                            ],
                          );
                        }
                      },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('You are not authenticated.'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to login page
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text('Login'),
                        ),
                      ],
                    ),
            ),
          );
        }
      },
    );
  }
}







