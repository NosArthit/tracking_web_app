import 'package:flutter/material.dart';

class ExportFilePage extends StatefulWidget {
  const ExportFilePage({super.key});

  @override
  _ExportFilePageState createState() => _ExportFilePageState();
}

class _ExportFilePageState extends State<ExportFilePage> {
  final _imeiController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  List<String> _headers = [
    'date_server', 'time_server', 'imei', 'date_device', 'time_device',
    'latitude', 'latitude_direction', 'longitude', 'longitude_direction',
    'speed', 'course', 'alt', 'sats', 'hdop', 'inputs', 'outputs', 'adc',
    'ibutton', 'params_id', 'crc16'
  ];

  List<List<String>> _data = [];

  void _fetchData() {
    // ฟังก์ชันนี้จะใช้ดึงข้อมูลจาก API และจัดเก็บในตัวแปร
    // เพิ่มข้อมูลที่ดึงมาในตัวแปร _data
  }

  void _exportToExcel() {
    // ฟังก์ชันนี้จะใช้ในการสร้างและส่งออกข้อมูลไปยัง Excel
    // ที่นี่เป็นเพียงตัวอย่างการแสดงผลของตาราง
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Export to Excel'),
          content: Text('Export functionality is not yet implemented.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export Data'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _imeiController,
              decoration: InputDecoration(labelText: 'IMEI'),
            ),
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Start Date (yyyy-mm-dd)'),
            ),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date (yyyy-mm-dd)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exportToExcel,
              child: Text('Export to Excel'),
            ),
            SizedBox(height: 20),
            // Horizontal scrollable DataTable
            Padding(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.antiAlias,
                child: 
                    DataTable(
                      horizontalMargin: 5.0,
                      columns: _headers.map((header) => DataColumn(label: Text(header))).toList(),
                      rows: _data.map(
                        (row) => DataRow(
                          cells: row.map((value) => DataCell(Text(value))).toList(),
                        ),
                      ).toList(),
                    ),


              ),
            ),
          ],
        ),
      ),
    );
  }
}















        

