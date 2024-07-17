import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

class LayOutResPage extends StatefulWidget {
  @override
  State<LayOutResPage> createState() => _LayOutResPageState();
}

class _LayOutResPageState extends State<LayOutResPage> {
  String imei = '';
  String startDate = '';
  String endDate = '';
  List<Map<String, dynamic>> dateRangeData = [];
  Map<String, dynamic>? latestData;
  Timer? latestDataTimer;
  double latitude = 13.818840980529785;
  double longitude = 100.5317611694336;
  bool trackLocation = false;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> polylines = {};
  bool drawPolylineFromDataTableClicked = false;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(13.818840980529785,
        100.5317611694336), // Default to (0,0) before data is fetched
    zoom: 14.75,
  );

  CameraPosition _currentLocation = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(13.818840980529785,
        100.5317611694336), // Default to (0,0) before data is fetched
    tilt: 59.440717697143555,
    zoom: 14.75,
  );

  @override
  void initState() {
    super.initState();
    //startFetchingLatestData();
    drawPolylineFromDataTableClicked = false;
  }

  @override
  void dispose() {
    latestDataTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchLatestData() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/api/tracking/latest_data?imei=$imei'));
    if (response.statusCode == 200) {
      setState(() {
        latestData = json.decode(response.body) as Map<String, dynamic>;
        if (latestData != null) {
          // Convert UTC date_server to local date
          latestData!['date_server'] = DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(latestData!['date_server']).toLocal());
          // Convert UTC time_server to local time
          latestData!['time_server'] = DateFormat('HH:mm:ss')
              .format(DateTime.parse(latestData!['time_server']).toLocal());

          latitude = double.tryParse(latestData!['latitude'] ?? '') ?? 0.0;
          longitude = double.tryParse(latestData!['longitude'] ?? '') ?? 0.0;

          // Update _initialPosition and _currentLocation with the fetched coordinates
          _initialPosition = CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14.75,
          );

          _currentLocation = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(latitude, longitude),
            tilt: 59.440717697143555,
            zoom: 14.75,
          );

          // Add new coordinate
          if (drawPolylineFromDataTableClicked == false) {
            addPolylineCoordinates(LatLng(latitude, longitude));
          }

          // Move the map camera to the new location if tracking is enabled
          if (trackLocation) {
            _goToTheCar();
          }
        }
      });
    } else {
      // Handle error
      setState(() {
        latestData = null;
      });
    }
  }

  void startFetchingLatestData() {
    fetchLatestData(); // Fetch latest data immediately
    latestDataTimer?.cancel();
    latestDataTimer =
        Timer.periodic(Duration(seconds: 3), (Timer t) => fetchLatestData());
  }

  void clearPolylines() {
    setState(() {
      polylineCoordinates.clear();
      polylines.clear();
    });
  }

  void addPolylineCoordinates(LatLng newCoordinate) {
    setState(() {
      polylineCoordinates.add(newCoordinate);
      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.greenAccent,
          width: 5,
        ),
      );
    });
  }

  void _goToTheCar() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      _currentLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latitude, longitude),
        tilt: 59.440717697143555,
        zoom: 14.75,
      );
      controller
          .animateCamera(CameraUpdate.newCameraPosition(_currentLocation));
    });
  }

  Future<void> fetchDataByDateRange() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/api/tracking/data_by_date_range?imei=$imei&startDate=$startDate&endDate=$endDate'));
    if (response.statusCode == 200) {
      setState(() {
        var resultData = json.decode(response.body) as List<dynamic>;
        if (resultData.isNotEmpty) {
          dateRangeData = resultData.map((data) {
            return {
              'date_server': DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(data['date_server']).toLocal()),
              'time_server': DateFormat('HH:mm:ss')
                  .format(DateTime.parse(data['time_server']).toLocal()),
              'imei':
                  data['imei'].toString(), // Ensure all are converted to String
              'date_device': data['date_device'].toString(),
              'time_device': data['time_device'].toString(),
              'latitude': data['latitude'].toString(),
              'latitude_direction': data['latitude_direction'].toString(),
              'longitude': data['longitude'].toString(),
              'longitude_direction': data['longitude_direction'].toString(),
              'speed': data['speed'].toString(),
              'course': data['course'].toString(),
              'alt': data['alt'].toString(),
              'sats': data['sats'].toString(),
              'hdop': data['hdop'].toString(),
              'inputs': data['inputs'].toString(),
              'outputs': data['outputs'].toString(),
              'adc': data['adc'].toString(),
              'ibutton': data['ibutton'].toString(),
              'params_id': data['params_id'].toString(),
              'crc16': data['crc16'].toString()
              // Add other key-value pairs from resultData as needed
            };
          }).toList();
        } else {
          dateRangeData = [];
        }
      });
    } else {
      // Handle error
      setState(() {
        dateRangeData = [];
      });
    }
  }

  void drawPolylineFromDataTable() {
    if (dateRangeData.isNotEmpty &&
        dateRangeData.first['latitude'] != null &&
        dateRangeData.first['longitude'] != null) {
      setState(() {
        polylineCoordinates.clear();
        polylines.clear();
        for (var data in dateRangeData) {
          if (data['latitude'] != null && data['longitude'] != null) {
            double lat = double.tryParse(data['latitude'] ?? '0.0') ?? 0.0;
            double lng = double.tryParse(data['longitude'] ?? '0.0') ?? 0.0;
            polylineCoordinates.add(LatLng(lat, lng));
          }
        }
        if (polylineCoordinates.isNotEmpty) {
          polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.red,
              width: 5,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Layout สำหรับหน้าจอขนาดเล็ก (มือถือ)
            return buildMobileLayout();
          } else if (constraints.maxWidth < 1200) {
            // Layout สำหรับหน้าจอขนาดกลาง (แท็บเล็ต)
            return buildTabletLayout();
          } else {
            // Layout สำหรับหน้าจอขนาดใหญ่ (เดสก์ท็อป)
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
            Text(
              'Welcome to My Web Page',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
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
            Text(
              'Welcome to My Web Page',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
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
            Container(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'GPS Tracking Map',
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
            SizedBox(height: 20),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                height: 500,
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _initialPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  polylines: polylines,
                  markers: {
                    Marker(
                      markerId: MarkerId('currentLocation'),
                      position: LatLng(latitude, longitude),
                      infoWindow: InfoWindow(
                        title: 'Current Location',
                        snippet: 'IMEI: $imei',
                      ),
                    ),
                  },
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: latestData != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Latest Data:'),
                        ...latestData!.entries.map((entry) {
                          return Text('${entry.key}: ${entry.value}');
                        }).toList(),
                      ],
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Text('No data available')),
            ))
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter IMEI',
                        ),
                        onChanged: (value) {
                          imei = value;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            drawPolylineFromDataTableClicked =
                                false; // Reset the flag
                          });
                          clearPolylines();
                          startFetchingLatestData();
                        },
                        child: Text('Fetch Latest Data'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: latestData != null
                            ? () {
                                if (drawPolylineFromDataTableClicked == true) {
                                  clearPolylines();
                                  _goToTheCar();
                                } else {
                                  _goToTheCar();
                                }
                              }
                            : null,
                        child: Text("Go to Current Location"),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text("Track Current Location"),
                          Switch(
                            value: trackLocation,
                            onChanged: latestData != null
                                ? (isChecked) {
                                    setState(() {
                                      trackLocation = isChecked;
                                    });
                                    if (isChecked) {
                                      if (drawPolylineFromDataTableClicked ==
                                          true) {
                                        clearPolylines();
                                        _goToTheCar();
                                      } else {
                                        _goToTheCar();
                                      }
                                    }
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Start Date (yyyy-MM-dd)',
                        ),
                        onChanged: (value) {
                          startDate = value;
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'End Date (yyyy-MM-dd)',
                        ),
                        onChanged: (value) {
                          endDate = value;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (drawPolylineFromDataTableClicked == true) {
                            clearPolylines();
                            fetchDataByDateRange();
                            drawPolylineFromDataTableClicked =
                                false; // Reset the flag
                          } else {
                            fetchDataByDateRange();
                          }
                        },
                        child: Text('Fetch Data by Date Range'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: dateRangeData.isNotEmpty
                            ? () {
                                drawPolylineFromDataTableClicked =
                                    true; // Set the flag
                                clearPolylines();
                                drawPolylineFromDataTable();
                              }
                            : null,
                        child: Text('Draw Route'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'GPS Tracking History by Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                dateRangeData.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 10,
                          columns: dateRangeData.first.keys.map((key) {
                            return DataColumn(
                              label: Text(key),
                              numeric:
                                  false, // Change to true if the column should be numeric
                            );
                          }).toList(),
                          rows: dateRangeData.map((entry) {
                            return DataRow(
                              cells: entry.values.map((value) {
                                return DataCell(
                                  Text(value.toString()),
                                  // Add more properties here if needed
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Text(
                            'No data available for the specified date range')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
