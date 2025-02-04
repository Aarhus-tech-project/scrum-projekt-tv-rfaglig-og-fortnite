import 'package:classroom_finder_app/RoomLocation.dart';
import 'package:compassx/compassx.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Compass extends StatefulWidget {
  final RoomLocation Room;
  const Compass({super.key, required this.Room});

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  double angleToTarget = 0.0; // Angle in degress offset from north to target

  double startLatitude = 56.11370211968747;
  double startLongtitude = 10.126561169173625;

  double targetLatitude = 56.11374204896286;
  double targetLongtitude = 10.126310686422762;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            widget.Room.name,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // Define the action when the text is clicked
                  print('Text clicked');
                },
                child: Icon(
                  Icons.map,
                  size: 40,
                  color: Colors.white,
                )),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.Room.name,
                    style: TextStyle(
                        fontSize: 30, decoration: TextDecoration.underline),
                  ),
                  Text("Etage ${widget.Room.level}",
                      style: TextStyle(
                          fontSize: 30, decoration: TextDecoration.underline))
                ],
              ),
            ),
            Expanded(
              child: Center(
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          }

                          var position = snapshot.data;

                          angleToTarget = Geolocator.bearingBetween(
                              position!.latitude,
                              position.longitude,
                              targetLatitude,
                              targetLongtitude);

                          return Text(
                              "longitude: ${position.longitude.toStringAsFixed(8)}\n latitude: ${position.latitude.toStringAsFixed(8)}\n altitude: ${position.altitude.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center);
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Latitude: ${widget.Room.latitude}'\nLongitude: ${widget.Room.longitude}\nAltitude: ${widget.Room.altitude}",
              style:
                  TextStyle(fontSize: 30, decoration: TextDecoration.underline),
            ),
            Text("Etage 1", style: TextStyle(fontSize: 30))
          ],
        )));
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
