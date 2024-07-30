//user_details
import 'package:flutter/material.dart';

class UserAdminDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> userDetails;
  final List<Map<String, dynamic>> adminDetails;
  final String token;

  UserAdminDetailsPage({
    required this.userDetails,
    required this.adminDetails,
    required this.token,
  });

  @override
  _UserAdminDetailsPageState createState() => _UserAdminDetailsPageState();
}

class _UserAdminDetailsPageState extends State<UserAdminDetailsPage> {
  void _selectUser(Map<String, dynamic> user) {
    Navigator.pop(context, {'type': 'user', 'data': user});
  }

  void _selectAdmin(Map<String, dynamic> admin) {
    Navigator.pop(context, {'type': 'admin', 'data': admin});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('User and Admin Details'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'User Details'),
              Tab(text: 'Admin Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserDetailsTable(),
            _buildAdminDetailsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('User ID')),
          DataColumn(label: Text('Firstname')),
          DataColumn(label: Text('Lastname')),
          DataColumn(label: Text('Company')),
          DataColumn(label: Text('Address')),
          DataColumn(label: Text('City')),
          DataColumn(label: Text('State')),
          DataColumn(label: Text('Country')),
          DataColumn(label: Text('Postal Code')),
          DataColumn(label: Text('Phone')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Date Info Update')),
          DataColumn(label: Text('Time Info Update')),
        ],
        rows: widget.userDetails.map((user) {
          return DataRow(
            cells: [
              DataCell(Text(user['date'] ?? '')),
              DataCell(Text(user['time'] ?? '')),
              DataCell(Text(user['user_id']?.toString() ?? '')),
              DataCell(Text(user['firstname'] ?? '')),
              DataCell(Text(user['lastname'] ?? '')),
              DataCell(Text(user['company'] ?? '')),
              DataCell(Text(user['address'] ?? '')),
              DataCell(Text(user['city'] ?? '')),
              DataCell(Text(user['state'] ?? '')),
              DataCell(Text(user['country'] ?? '')),
              DataCell(Text(user['postal_code'] ?? '')),
              DataCell(Text(user['phone'] ?? '')),
              DataCell(Text(user['email'] ?? '')),
              DataCell(Text(user['status']?.toString() ?? '')),
              DataCell(Text(user['date_info_update'] ?? '')),
              DataCell(Text(user['time_info_update'] ?? '')),
            ],
            onSelectChanged: (selected) {
              if (selected != null && selected) {
                _selectUser(user);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdminDetailsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Admin ID')),
          DataColumn(label: Text('User ID')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Register Date')),
          DataColumn(label: Text('Register Time')),
          DataColumn(label: Text('Reference Email')),
        ],
        rows: widget.adminDetails.map((admin) {
          return DataRow(
            cells: [
              DataCell(Text(admin['date'] ?? '')),
              DataCell(Text(admin['admin_id']?.toString() ?? '')),
              DataCell(Text(admin['user_id']?.toString() ?? '')),
              DataCell(Text(admin['email'] ?? '')),
              DataCell(Text(admin['status']?.toString() ?? '')),
              DataCell(Text(admin['date_register'] ?? '')),
              DataCell(Text(admin['time_register'] ?? '')),
              DataCell(Text(admin['ref_email'] ?? '')),
            ],
            onSelectChanged: (selected) {
              if (selected != null && selected) {
                _selectAdmin(admin);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}






