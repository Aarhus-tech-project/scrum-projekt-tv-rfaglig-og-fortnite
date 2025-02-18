import 'package:classroom_finder_app/Models/Room.dart';
import 'package:compassx/compassx.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:material_symbols_icons/symbols.dart';

class ClassroomCompassPage extends StatefulWidget {
  final Room room;
  const ClassroomCompassPage({super.key, required this.room});

  @override
  State<ClassroomCompassPage> createState() => _ClassroomCompassPageState();
}

class _ClassroomCompassPageState extends State<ClassroomCompassPage> {
  double angleToTarget = 0.0; // Angle in degress offset from north to target
  double startLatitude = 0.0;
  double startLongitude = 0.0;

  late double targetLatitude;
  late double targetLongtitude;
  late double targetAltitude;
  late int level;

  @override
  void initState() {
    super.initState();
    targetLatitude = widget.room.latitude;
    targetLongtitude = widget.room.longitude;
    targetAltitude = widget.room.altitude;
    level = widget.room.level;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(''),
        actions: [
          TextButton(
              onPressed: () {},
              child: Icon(
                Icons.map,
                size: 40,
                color: const Color.fromARGB(255, 0, 0, 0),
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.meeting_room,
                            size: 35,
                          ),
                          Text(" ${widget.room.name}",
                              style: TextStyle(fontSize: 30)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Symbols.floor, size: 35),
                          Text(" ${getfloor()}",
                              style: TextStyle(fontSize: 30)),
                        ],
                      ),
                    ],
                  ),
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
                      return Transform.rotate(
                        angle: (-newHeading * 0.0174532925),
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          size: MediaQuery.of(context).size.width - 80,
                        ),
                      );
                    },
                  ),
                  GPSText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<Position> GPSText() {
    return StreamBuilder(
        stream: LocationUtils.getContinuousLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          var position = snapshot.data;
          angleToTarget = Geolocator.bearingBetween(position!.latitude,
              position.longitude, targetLatitude, targetLongtitude);
          startLatitude = position.latitude;
          startLongitude = position.longitude;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.directions_run, size: 35),
              Text(
                  "${Geolocator.distanceBetween(startLatitude, startLongitude, targetLatitude, targetLongtitude).toStringAsFixed(2)}m",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: accuracyIcon(position.accuracy),
              ),
            ],
          );
        });
  }

  String getfloor() {
    switch (widget.room.level) {
      case 0:
        return "Ground Floor";
      case 1:
        return "1st Floor";
      case 2:
        return "2nd Floor";
      case 3:
        return "3rd Floor";
      default:
        return "${widget.room.level}th Floor";
    }
  }

  Icon accuracyIcon(double accuracy) {
    if (accuracy < 10) {
      return Icon(Icons.circle, color: Colors.green, size: 20);
    } else if (accuracy < 20) {
      return Icon(Icons.circle, color: Colors.yellow, size: 20);
    } else {
      return Icon(Icons.circle, color: Colors.red, size: 20);
    }
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
