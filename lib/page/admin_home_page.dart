//admin_home_page
import 'package:flutter/material.dart';
import 'package:my_web_app/components/custom_status.dart';
import 'package:my_web_app/components/custom_textfield_admin.dart';
import 'package:my_web_app/components/custom_textfield_admin_approval.dart';
import 'package:my_web_app/components/custom_textfield_input.dart';
import 'package:my_web_app/components/custom_textfield_output.dart';
import 'package:my_web_app/components/custom_textfield_user.dart';
import 'package:my_web_app/components/text_editing_controller.dart';
import 'package:my_web_app/page/user_details_page.dart';
import 'package:my_web_app/service/adminapi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final AdminApiService _apiService = AdminApiService();
  Timer? _timer;
  int _remainingTime = 0;
  String _email = '';
  String _adminId = '';
  String _token = '';
  String _status = 'false';

  final TextEditingControllers _controllers =
      TextEditingControllers(); // Initialize controllers

  List<Map<String, dynamic>> _fetchedUserData = [];
  List<Map<String, dynamic>> _fetchedAdminData = [];

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

  Future<void> _fetchUserData() async {
    try {
      final data = await _apiService.fetchUserData(
        date: _controllers.dateController.text,
        time: _controllers.timeController.text,
        userId: _controllers.userIdController.text,
        firstname: _controllers.firstnameController.text,
        lastname: _controllers.lastnameController.text,
        company: _controllers.companyController.text,
        address: _controllers.addressController.text,
        city: _controllers.cityController.text,
        state: _controllers.stateController.text,
        country: _controllers.countryController.text,
        postalCode: _controllers.postalCodeController.text,
        phone: _controllers.phoneController.text,
        email: _controllers.emailController.text,
        status: _status,
        dateInfoUpdate: _controllers.dateInfoUpdateController.text,
        timeInfoUpdate: _controllers.timeInfoUpdateController.text,
        token: _token,
      );
      setState(() {
        _fetchedUserData = List<Map<String, dynamic>>.from(data);
      });
      _navigateToUserAdminDetailsPage();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchAdminData() async {
    try {
      final data = await _apiService.fetchAdminData(
        date: _controllers.dateController.text,
        time: _controllers.timeController.text,
        userId: _controllers.userIdController.text,
        firstname: _controllers.firstnameController.text,
        lastname: _controllers.lastnameController.text,
        company: _controllers.companyController.text,
        address: _controllers.addressController.text,
        city: _controllers.cityController.text,
        state: _controllers.stateController.text,
        country: _controllers.countryController.text,
        postalCode: _controllers.postalCodeController.text,
        phone: _controllers.phoneController.text,
        email: _controllers.emailController.text,
        status: _status,
        dateInfoUpdate: _controllers.dateInfoUpdateController.text,
        timeInfoUpdate: _controllers.timeInfoUpdateController.text,
        token: _token,
      );
      setState(() {
        _fetchedAdminData = List<Map<String, dynamic>>.from(data);
      });
      _navigateToUserAdminDetailsPage();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigateToUserAdminDetailsPage() async {
    final selectedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAdminDetailsPage(
          userDetails: _fetchedUserData,
          adminDetails: _fetchedAdminData,
          token: _token,
        ),
      ),
    );

    if (selectedData != null) {
      if (selectedData['type'] == 'user') {
        final selectedUser = selectedData['data'];
        setState(() {
          _controllers.dateController2.text = selectedUser['date'] ?? '';
          _controllers.timeController2.text = selectedUser['time'] ?? '';
          _controllers.userIdController2.text = selectedUser['user_id'] ?? '';
          _controllers.firstnameController2.text =
              selectedUser['firstname'] ?? '';
          _controllers.lastnameController2.text =
              selectedUser['lastname'] ?? '';
          _controllers.companyController2.text = selectedUser['company'] ?? '';
          _controllers.addressController2.text = selectedUser['address'] ?? '';
          _controllers.cityController2.text = selectedUser['city'] ?? '';
          _controllers.stateController2.text = selectedUser['state'] ?? '';
          _controllers.countryController2.text = selectedUser['country'] ?? '';
          _controllers.postalCodeController2.text =
              selectedUser['postal_code'] ?? '';
          _controllers.phoneController2.text = selectedUser['phone'] ?? '';
          _controllers.emailController2.text = selectedUser['email'] ?? '';
          _controllers.statusController2.text =
              (selectedUser['status']?.toString() == 'true')
                  ? 'Approved'
                  : 'Not Approved';
          _controllers.dateInfoUpdateController2.text =
              selectedUser['date_info_update'] ?? '';
          _controllers.timeInfoUpdateController2.text =
              selectedUser['time_info_update'] ?? '';
        });
      } else if (selectedData['type'] == 'admin') {
        final selectedAdmin = selectedData['data'];
        setState(() {
          _controllers.adminIdController5.text =
              selectedAdmin['admin_id'] ?? '';
          _controllers.userIdController5.text = selectedAdmin['user_id'] ?? '';
          _controllers.emailController5.text = selectedAdmin['email'] ?? '';
          _controllers.statusController5.text =
              (selectedAdmin['status']?.toString() == 'true')
                  ? 'Approved'
                  : 'Not Approved';
          _controllers.registerDateController5.text =
              selectedAdmin['date_register'] ?? '';
          _controllers.registerTimeController5.text =
              selectedAdmin['time_register'] ?? '';
          _controllers.referenceEmailController5.text =
              selectedAdmin['ref_email'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUser() async {
    try {
      await AdminApiService().updateUser(
        userId: _controllers.userIdController2.text,
        firstname: _controllers.firstnameController2.text,
        lastname: _controllers.lastnameController2.text,
        company: _controllers.companyController2.text,
        address: _controllers.addressController2.text,
        city: _controllers.cityController2.text,
        state: _controllers.stateController2.text,
        country: _controllers.countryController2.text,
        postalCode: _controllers.postalCodeController2.text,
        phone: _controllers.phoneController2.text,
        email: _controllers.emailController2.text,
        token: _token,
      );

      print('User data updated successfully');
    } catch (e) {
      print('Failed to update user data: $e');
    }
  }

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  Future<void> _updateUserStatus() async {
    try {
      final input = _controllers.userController3.text;
      final isEmail = isValidEmail(input);

      await AdminApiService().updateUserStatus(
        userId: isEmail ? null : input,
        email: isEmail ? input : null,
        status: _controllers.statusController3.text,
        token: _token,
      );

      print('User status updated successfully');
    } catch (e) {
      print('Failed to update user status: $e');
    }
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

      print('User status updated successfully');
    } catch (e) {
      print('Failed to update user status: $e');
    }
  }

  Future<void> _deleteUser() async {
    try {
      final userId = _controllers.userIdController2.text.trim().toString();
      final email = _controllers.emailController2.text.trim().toString();

      if (userId.isEmpty && email.isEmpty) {
        throw Exception('User ID or Email must be provided');
      }

      final isEmail = isValidEmail(email);

      await AdminApiService().deleteUser(
        userId: isEmail ? null : userId,
        email: isEmail ? email : null,
        token: _token,
      );

      print('User deleted successfully');
    } catch (e) {
      print('Failed to delete user account: $e');
    }
  }

  Future<void> _deleteAdmin() async {
    try {
      final userId = _controllers.userIdController5.text.trim().toString();
      final email = _controllers.emailController5.text.trim().toString();

      if (userId.isEmpty && email.isEmpty) {
        throw Exception('User ID or Email must be provided');
      }

      final isEmail = isValidEmail(email);

      await AdminApiService().deleteUser(
        userId: isEmail ? null : userId,
        email: isEmail ? email : null,
        token: _token,
      );

      print('User deleted successfully');
    } catch (e) {
      print('Failed to delete user account: $e');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/admin_login');
  }

  Future<bool?> _dialogBack() async {
    final prefs = await SharedPreferences.getInstance();
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
              onPressed: () async {
                await prefs.clear();
                Navigator.pushReplacementNamed(context, '/admin_login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final bool shouldPop = await _dialogBack() ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Admin Home Page'),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: _dialogBack,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(25),
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Logged in as: $_email',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Admin ID: $_adminId',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Token Remaining Time: ${formatRemainingTime(_remainingTime)}',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        //Text('Token expires in: $_remainingTime seconds'),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Card(
                        child: Column(
                          children: <Widget>[
                            Text("Insert Your Data one or more to search"),
                            SizedBox(
                              height: 16,
                            ),
                            CustomTextFieldInput(
                              controller: _controllers.dateController,
                              hintText: "Register Date",
                              icon: Icons.calendar_month,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.timeController,
                              hintText: "Register Time",
                              icon: Icons.watch_later_outlined,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.userIdController,
                              hintText: "User ID",
                              icon: Icons.person,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.firstnameController,
                              hintText: "First Name",
                              icon: Icons.person,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.lastnameController,
                              hintText: "Last Name",
                              icon: Icons.person,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.companyController,
                              hintText: "Company",
                              icon: Icons.maps_home_work_outlined,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.addressController,
                              hintText: "Address",
                              icon: Icons.home,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.cityController,
                              hintText: "City",
                              icon: Icons.maps_home_work_outlined,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.stateController,
                              hintText: "State",
                              icon: Icons.maps_home_work_outlined,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.countryController,
                              hintText: "Country",
                              icon: Icons.maps_home_work_outlined,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.postalCodeController,
                              hintText: "Postal Code",
                              icon: Icons.numbers,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.phoneController,
                              hintText: "Phone",
                              icon: Icons.phone,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.emailController,
                              hintText: "Email",
                              icon: Icons.email,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.dateInfoUpdateController,
                              hintText: "The Lastest Update",
                              icon: Icons.calendar_month,
                            ),
                            SizedBox(height: 10.0),
                            CustomTextFieldInput(
                              controller: _controllers.timeInfoUpdateController,
                              hintText: "The Lastest Update",
                              icon: Icons.watch_later_outlined,
                            ),
                            SizedBox(height: 22.0),
                            StatusRow(
                              status: _status,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _status = newValue != null && newValue
                                      ? 'true'
                                      : 'false';
                                });
                              },
                            ),
                            SizedBox(height: 25.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: _fetchUserData,
                                  child: Text('Fetch User Data'),
                                ),
                                SizedBox(width: 16.0),
                                ElevatedButton(
                                  onPressed: _fetchAdminData,
                                  child: Text('Fetch Admin Data'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Card(
                        child: Column(
                          children: <Widget>[
                            Text("Edit data in Box below"),
                            SizedBox(height: 16.0),
                            CustomTextFieldOutput(
                              controller: _controllers.dateController2,
                              enable: false,
                              hintText: "Date",
                              icon: Icons.calendar_month_sharp,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.timeController2,
                              enable: false,
                              hintText: "Time",
                              icon: Icons.watch_later_outlined,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.userIdController2,
                              enable: false,
                              hintText: "User ID",
                              icon: Icons.person,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.firstnameController2,
                              enable: true,
                              hintText: "First Name",
                              icon: Icons.person,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.lastnameController2,
                              enable: true,
                              hintText: "Last Name",
                              icon: Icons.person,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.companyController2,
                              enable: true,
                              hintText: "Company",
                              icon: Icons.maps_home_work_outlined,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.addressController2,
                              enable: true,
                              hintText: "Address",
                              icon: Icons.maps_home_work_outlined,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.cityController2,
                              enable: true,
                              hintText: "City",
                              icon: Icons.maps_home_work_outlined,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.stateController2,
                              enable: true,
                              hintText: "State",
                              icon: Icons.maps_home_work_outlined,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.countryController2,
                              enable: true,
                              hintText: "Country",
                              icon: Icons.maps_home_work_outlined,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.postalCodeController2,
                              enable: true,
                              hintText: "Postal Code",
                              icon: Icons.numbers,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.phoneController2,
                              enable: true,
                              hintText: "Phone",
                              icon: Icons.phone,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.emailController2,
                              enable: true,
                              hintText: "Email",
                              icon: Icons.email,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller: _controllers.statusController2,
                              enable: false,
                              hintText: "Status",
                              icon: Icons.check_rounded,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller:
                                  _controllers.dateInfoUpdateController2,
                              enable: false,
                              hintText: "Latest Date Info Update",
                              icon: Icons.calendar_month,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldOutput(
                              controller:
                                  _controllers.timeInfoUpdateController2,
                              enable: false,
                              hintText: "Latest Time Info Update",
                              icon: Icons.watch_later_outlined,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: _updateUser,
                                    child: Text("Update User Account")),
                                SizedBox(
                                  width: 16.0,
                                ),
                                ElevatedButton(
                                    onPressed: _deleteUser,
                                    child: Text("Delete User Account")),
                              ],
                            ),
                            SizedBox(height: 25.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  CustomTextFieldAdmin(
                    controller: _controllers.adminIdController5,
                    enable: false,
                    hintText: "Admin ID",
                    icon: Icons.person,
                  ),
                  CustomTextFieldAdmin(
                    controller: _controllers.userIdController5,
                    enable: false,
                    hintText: "User ID",
                    icon: Icons.person,
                  ),
                  CustomTextFieldAdmin(
                    controller: _controllers.emailController5,
                    enable: false,
                    hintText: "Admin Email",
                    icon: Icons.email,
                  ),
                  CustomTextFieldAdmin(
                    controller: _controllers.statusController5,
                    enable: false,
                    hintText: "Admin Status",
                    icon: Icons.check_rounded,
                  ),
                  CustomTextFieldAdmin(
                    controller: _controllers.registerDateController5,
                    enable: false,
                    hintText: "Admin Registered Date",
                    icon: Icons.calendar_month,
                  ),
                  CustomTextFieldAdmin(
                    controller: _controllers.registerTimeController5,
                    enable: false,
                    hintText: "Admin Registered Time",
                    icon: Icons.watch_later_outlined,
                  ),
                  CustomTextFieldAdmin(
                    controller: _controllers.referenceEmailController5,
                    enable: false,
                    hintText: "Reference Email Approval",
                    icon: Icons.email,
                  ),
                  SizedBox(height: 25.0),
                  SizedBox(height: 25.0),
                  ElevatedButton(
                      onPressed: _deleteAdmin,
                      child: Text("Delete Admin Account")),
                  SizedBox(height: 25.0),
                  CustomTextFieldUser(
                    controller: _controllers.userController3,
                    hintText: "UserID or Email",
                    icon: Icons.person,
                  ),
                  StatusRow(
                    status: _controllers.statusController3.text,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _controllers.statusController3.text =
                            newValue != null && newValue ? 'true' : 'false';
                      });
                    },
                  ),
                  SizedBox(height: 25.0),
                  ElevatedButton(
                      onPressed: _updateUserStatus,
                      child: Text("Approve User Account")),
                  CustomTextFieldAdminApproval(
                    controller: _controllers.userController4,
                    hintText: "UserID or Email",
                    icon: Icons.person,
                  ),
                  CustomTextFieldAdminApproval(
                    controller: _controllers.refEmailController4,
                    hintText: "Reference Email",
                    icon: Icons.email,
                  ),
                  StatusRow(
                    status: _controllers.statusController4.text,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _controllers.statusController4.text =
                            newValue != null && newValue ? 'true' : 'false';
                      });
                    },
                  ),
                  SizedBox(height: 25.0),
                  ElevatedButton(
                      onPressed: _updateAdminStatus,
                      child: Text("Approve Admin Account")),
                ],
              ),
            ),
          ),
        ));
  }
}
