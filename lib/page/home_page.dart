import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_web_app/components/userDataContainer.dart';
import 'dart:convert';
import 'dart:async';
import 'package:my_web_app/page/data_utils.dart';
import 'package:my_web_app/service/trackingapi_service.dart';
import 'package:my_web_app/service/userapi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserApiService _userApiService = UserApiService();
  final TrackingApiService _trackingApiService = TrackingApiService();

  Map<String, dynamic>? _userData;
  Timer? _timer;
  int _remainingTime = 0;

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
    _fetchUserData();
    _startCountdown();
    drawPolylineFromDataTableClicked = false;
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final userData = await _userApiService.getUserDetails(token);
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
    latestDataTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchLatestData() async {
    try {
      final response = await _trackingApiService.fetchLatestData(imei);
      if (response.statusCode == 200) {
        setState(() {
          latestData = DataUtils.formatLatestData(
              json.decode(response.body) as Map<String, dynamic>);
          if (latestData != null) {
            latitude = double.tryParse(latestData!['latitude'] ?? '') ?? 0.0;
            longitude = double.tryParse(latestData!['longitude'] ?? '') ?? 0.0;

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

            if (drawPolylineFromDataTableClicked == false) {
              addPolylineCoordinates(LatLng(latitude, longitude));
            }

            if (trackLocation) {
              _goToTheCar();
            }
          }
        });
      } else {
        setState(() {
          latestData = null;
        });
      }
    } catch (e) {
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
    try {
      final response = await _trackingApiService.fetchDataByDateRange(
          imei, startDate, endDate);
      if (response.statusCode == 200) {
        setState(() {
          dateRangeData = DataUtils.formatDateRangeData(
              json.decode(response.body) as List<dynamic>);
        });
      } else {
        setState(() {
          dateRangeData = [];
        });
      }
    } catch (e) {
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
        backgroundColor: Colors.grey[200],
        title: Text(
          'GRB Tracking System',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
            UserDataContainer(
              userData: _userData,
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
            UserDataContainer(
              userData: _userData,
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
            UserDataContainer(
              userData: _userData,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black87,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 500,
                child: GoogleMap(
                  mapType: MapType.normal,
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
                color: Colors.deepPurple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter IMEI',
                            hintStyle: TextStyle(color: Colors.grey[400])),
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
                        child: const Text(
                          'Fetch Latest Data',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
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
                        child: Text("Go to Current Location",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text("Track Current Location",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
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
                color: Colors.deepPurple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Start Date (yyyy-MM-dd)',
                            hintStyle: TextStyle(color: Colors.grey[400])),
                        onChanged: (value) {
                          startDate = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'End Date (yyyy-MM-dd)',
                            hintStyle: TextStyle(color: Colors.grey[400])),
                        onChanged: (value) {
                          endDate = value;
                        },
                      ),
                      const SizedBox(height: 20),
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
                        child: Text('Fetch Data by Date Range',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
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
                        child: Text('Draw Route',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
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
          color: Colors.deepPurple[50],
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
