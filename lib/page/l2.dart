


import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  String imei = '';
  String startDate = '';
  String endDate = '';
  List<Map<String, dynamic>> dateRangeData = [];
  Map<String, dynamic>? latestData;
  Timer? latestDataTimer;
  double latitude = 0.0;
  double longitude = 0.0;
  bool trackLocation = false;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> polylines = {};
  bool drawPolylineFromDataTableClicked = false;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(0.0, 0.0), // Default to (0,0) before data is fetched
    zoom: 14.75,
  );

  CameraPosition _currentLocation = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(0.0, 0.0), // Default to (0,0) before data is fetched
    tilt: 59.440717697143555,
    zoom: 14.75,
  );

  @override
  void initState() {
    super.initState();
    startFetchingLatestData();
    drawPolylineFromDataTableClicked = false;
  }

  @override
  void dispose() {
    latestDataTimer?.cancel();
    super.dispose();
  }

  void startFetchingLatestData() {
    fetchLatestData(); // Fetch latest data immediately
    latestDataTimer?.cancel();
    latestDataTimer =
        Timer.periodic(Duration(seconds: 3), (Timer t) => fetchLatestData());
  }

  Future<void> fetchLatestData() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/latest_data?imei=$imei'));
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
            zoom: 14.4746,
          );

          _currentLocation = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(latitude, longitude),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414,
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

  Future<void> fetchDataByDateRange() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/data_by_date_range?imei=$imei&startDate=$startDate&endDate=$endDate'));
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

  void _goToTheCar() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      _currentLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latitude, longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
      );
      controller
          .animateCamera(CameraUpdate.newCameraPosition(_currentLocation));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GRB Tracking System",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'About',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Contact',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'GPS Tracking Map',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    height: 350,
                                    width: 450,

                                    child: GoogleMap(
                                      mapType: MapType.hybrid,
                                      initialCameraPosition: _initialPosition,
                                      onMapCreated:
                                          (GoogleMapController controller) {
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
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: latestData != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Latest Data:'),
                                            ...latestData!.entries.map((entry) {
                                              return Text(
                                                  '${entry.key}: ${entry.value}');
                                            }).toList(),
                                          ],
                                        )
                                      : Text('No data available'),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                      onPressed: () {
                                        if (drawPolylineFromDataTableClicked ==
                                            true) {
                                          clearPolylines();
                                          _goToTheCar();
                                        } else {
                                          _goToTheCar();
                                        }
                                      },
                                      child: Text("Go to Current Location"),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text("Track Current Location"),
                                        Switch(
                                          value: trackLocation,
                                          onChanged: (isChecked) {
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
                                          },
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
                                        if (drawPolylineFromDataTableClicked ==
                                            true) {
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
                                      child: Text('Draw Polyline'),
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
                          child: dateRangeData.isNotEmpty
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
                              : Text(
                                  'No data available for the specified date range'),
                        ),
                      ),
                    ],
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
