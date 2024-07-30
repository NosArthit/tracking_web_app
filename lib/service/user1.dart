import 'package:flutter/material.dart';
import 'package:my_web_app/service/userapi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserApiService _apiService = UserApiService();
  Map<String, dynamic>? _userData;
  Timer? _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _startCountdown();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final userData = await _apiService.getUserDetails(token);
      setState(() {
        _userData = userData;
      });
    }
  }

  void _startCountdown() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenExpiration = prefs.getInt('token_expiration');

    if (tokenExpiration != null) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final timeRemaining = tokenExpiration - now;
      if (timeRemaining > 0) {
        setState(() {
          _remainingTime = timeRemaining;
        });

        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (_remainingTime > 0) {
            setState(() {
              _remainingTime--;
            });
          } else {
            _timer?.cancel();
            _logout();
          }
        });
      } else {
        _logout();
      }
    }
  }

  void _logout() async {
    await UserApiService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remainingTime ~/ 3600;
    final minutes = (_remainingTime % 3600) ~/ 60;
    final seconds = _remainingTime % 60;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'GRB Tracking System',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Welcome, ${_userData!['firstname']} ${_userData!['lastname']} ${_userData!['user_id']} ${_userData!['company']}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Row(
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/homeuser');
                              },
                              child: Text(
                                'Home',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'About',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Contact',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Time remaining: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                  width: 15,
                ),
                    ]),
              ],
            ),
    );
  }
}
