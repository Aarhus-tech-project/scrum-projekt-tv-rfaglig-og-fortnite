import 'dart:math';

import 'package:classroom_finder_app/CompassPage.dart';
import 'package:classroom_finder_app/DistanceClass.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'services/classroom_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

Future<Position> getPreciseLocation() async {
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
    desiredAccuracy: LocationAccuracy.bestForNavigation, // Highest accuracy
  );
}

Future<void> requestLocationPermissions() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    print(
        'Location permissions are permanently denied. Please enable them in settings.');
    await Geolocator.openAppSettings();
  }

  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    print("Location permission granted");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();
  List<RoomLocation> classrooms = [];
  List<RoomLocation> filteredClassrooms = [];
  late Future<List<RoomLocation>> futureClassrooms;

  @override
  void initState() {
    super.initState();

    futureClassrooms = ClassroomService().fetchClassrooms();
    futureClassrooms.then((data) {
      setState(() {
        classrooms = data;
        filteredClassrooms = classrooms;
      });
    });
    controller.addListener(() {
      filterClassrooms();
    });
  }

  void filterClassrooms() {
    List<RoomLocation> results = [];
    if (controller.text.isEmpty) {
      results = classrooms;
    } else {
      results = classrooms
          .where((classroom) => classroom.name
              .toLowerCase()
              .contains(controller.text.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredClassrooms = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Classroom Compass',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Search for Classroom',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 30),
              ),
              Expanded(
                child: Container(
                  height: 150, // Set a fixed height for the ListView
                  child: ListView.builder(
                    itemCount: filteredClassrooms
                        .length, // Number of items in the list
                    itemBuilder: (context, index) {
                      // Define the items in the list
                      return Container(
                          height: 70,
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      Compass(Room: filteredClassrooms[index]),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.room,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                Text(
                                  filteredClassrooms[index].name,
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black),
                                ),
                                Text("10m",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.black)),
                              ],
                            ),
                          ));
                    },
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
