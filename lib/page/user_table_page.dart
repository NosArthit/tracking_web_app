import 'package:flutter/material.dart';

class UserTablePage extends StatelessWidget {
  final List<Map<String, dynamic>> userData;

  UserTablePage({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: userData.isEmpty
          ? Center(child: Text('No user data available'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('User ID')),
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
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
                rows: userData.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user['date'] ?? '')),
                    DataCell(Text(user['time'] ?? '')),
                    DataCell(Text(user['user_id'] ?? '')),
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
                    DataCell(Text(user['status'] ?? '')),
                    DataCell(Text(user['date_info_update'] ?? '')),
                    DataCell(Text(user['time_info_update'] ?? '')),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}
