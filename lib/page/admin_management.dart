import 'package:flutter/material.dart';
import 'package:my_web_app/components/admin_page_container.dart';
import 'package:my_web_app/components/check_box.dart';
import 'package:my_web_app/components/custom_textfield_user_admin.dart';

import 'package:my_web_app/components/text_editing_controller.dart';
import 'package:my_web_app/service/adminapi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AdminManagement extends StatefulWidget {
  const AdminManagement({super.key});

  @override
  State<AdminManagement> createState() => _AdminManagementState();
}

class _AdminManagementState extends State<AdminManagement> {
  Timer? _timer;
  int _remainingTime = 0;
  String _email = '';
  String _adminId = '';
  String _token = '';

  final TextEditingControllers _controllers = TextEditingControllers();

  @override
  void initState() {
    super.initState();
    _loadAdminData();
    _startCountdownTimer();
  }

  Future<void> _loadAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? '';
      _adminId = prefs.getString('admin_id') ?? '';
      _token = prefs.getString('token') ?? '';
      final tokenExpiration = prefs.getInt('token_expiration') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      _remainingTime = tokenExpiration - currentTime;
    });
  }

  String formatRemainingTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();
          _logout();
        }
      });
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/admin_login');
  }

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  Future<void> _updateAdminStatus() async {
    try {
      final input = _controllers.userController4.text;
      final isEmail = isValidEmail(input);

      await AdminApiService().updateAdminStatus(
        userId: isEmail ? null : input,
        email: isEmail ? input : null,
        status: _controllers.statusController4.text,
        refEmail: _controllers.refEmailController4.text,
        token: _token,
      );

      //print('User status updated successfully');
      return;
    } catch (e) {
      //print('Failed to update user status: $e');
      return;
      
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Layout for mobile
            return buildMobileLayout();
          } else if (constraints.maxWidth < 1200) {
            // Layout for tablet
            return buildTabletLayout();
          } else {
            // Layout for desktop
            return buildDesktopLayout();
          }
        },
      ),
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AdminPageContainer(
              userEmail: _email,
              userID: _adminId,
              onLogout: _logout,
              remainingTime: _remainingTime,
            ),
            const SizedBox(height: 10),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AdminPageContainer(
              userEmail: _email,
              userID: _adminId,
              onLogout: _logout,
              remainingTime: _remainingTime,
            ),
            const SizedBox(height: 14),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildDesktopLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AdminPageContainer(
              userEmail: _email,
              userID: _adminId,
              onLogout: _logout,
              remainingTime: _remainingTime,
            ),
            const SizedBox(height: 20),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Admin Management",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              SizedBox(
                height: 32.0,
              ),
              Text(
                "Insert Your Data one or more to search",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 5.0,
              ),
              Card(
                color: Colors.purple[100],
                child: Padding(
                  padding: EdgeInsets.all(8.8),
                  child: SizedBox(
                    width: 650,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                CustomTextFieldUserAdmin(
                                  controller: _controllers.userController4,
                                  hintText: "UserID or Email",
                                  icon: Icons.person,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                CustomTextFieldUserAdmin(
                                  controller: _controllers.refEmailController4,
                                  hintText: "Reference Email",
                                  icon: Icons.email,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                StatusRow(
                                  status: _controllers.statusController4.text,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      _controllers.statusController4.text =
                                          newValue != null && newValue
                                              ? 'true'
                                              : 'false';
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: _updateAdminStatus,
                                      child: Text(
                                        "Approve Admin Account",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                        )
                                      ),
                                      style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.deepPurple[900],
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
