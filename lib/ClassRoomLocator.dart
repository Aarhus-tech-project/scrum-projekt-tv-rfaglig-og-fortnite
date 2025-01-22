import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ClassCompass extends StatefulWidget {
  const ClassCompass({super.key});

  @override
  State<ClassCompass> createState() => _ClassCompassState();
}

class _ClassCompassState extends State<ClassCompass> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
          future: LocationUtils.getPreciseLocation(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            var position = snapshot.data;
            return Text("longitude: ${position?.longitude}, latitude: ${position?.latitude}\n Angle: ${Geolocator.distanceBetween(position!.longitude, position.latitude, 0, 0)}", style: TextStyle(fontSize: 24), textAlign: TextAlign.center,);
          },
        ),
    );
  }
}

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  @override
  _CompassPageState createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double _heading = 0.0;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;

  @override
  void initState() {
    super.initState();
    startCompass();
  }

  void startCompass() {
    _magnetometerSubscription = magnetometerEventStream().listen((MagnetometerEvent event) {
      double x = event.x;
      double y = event.y;

      // Calculate heading in degrees (0 = North, 90 = East, etc.)
      double heading = atan2(y, x) * (180 / pi);

      // Normalize to 0-360 degrees
      if (heading < 0) {
        heading += 360;
      }

      setState(() {
        _heading = heading;
      });
    });
  }

  @override
  void dispose() {
    _magnetometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Compass Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Compass Heading:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_heading.toStringAsFixed(2)}°',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationUtils {
  static Future<Position> getPreciseLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // Get high-accuracy location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,  // Highest accuracy
    );
  }

  static Stream<Position> getContinuousLocation() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,  // High accuracy
        distanceFilter: 1,
      ),
    );
  }
}