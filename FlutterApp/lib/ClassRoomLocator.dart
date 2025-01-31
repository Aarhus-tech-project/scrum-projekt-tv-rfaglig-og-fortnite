import 'dart:async';

import 'package:compassx/compassx.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  @override
  _CompassPageState createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double angleToTarget = 0.0; // Angle in degress offset from north to target

  double startLatitude = 56.11370211968747;
  double startLongtitude = 10.126561169173625;

  double targetLatitude = 56.11374204896286;
  double targetLongtitude = 10.126310686422762;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Absolute Compass Heading")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<CompassXEvent>(
              stream: CompassX.events,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('No data');
                final compass = snapshot.data!;

                double newHeading =
                    (compass.heading + angleToTarget - 90) % 360;
                if (newHeading < 0) {
                  newHeading += 360;
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Angle To Target: ${angleToTarget.round()}'),
                    Text('Compass Heading: ${compass.heading.round()}'),
                    Text('New Heading: ${newHeading.round()}'),
                    Transform.rotate(
                      angle: (-newHeading * 0.0174532925),
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        size: MediaQuery.of(context).size.width - 80,
                      ),
                    ),
                  ],
                );
              },
            ),
            StreamBuilder(
                stream: LocationUtils.getContinuousLocation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  var position = snapshot.data;

                  angleToTarget = Geolocator.bearingBetween(position!.latitude,
                      position!.longitude, targetLatitude, targetLongtitude);

                  return Text(
                      "longitude: ${position?.longitude.toStringAsFixed(8)}\n latitude: ${position?.latitude.toStringAsFixed(8)}\n altitude: ${position?.altitude.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center);
                }),
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
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation, // Highest accuracy
      ),
    );
  }

  static Stream<Position> getContinuousLocation() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation, // High accuracy
        distanceFilter: 3,
      ),
    );
  }
}
