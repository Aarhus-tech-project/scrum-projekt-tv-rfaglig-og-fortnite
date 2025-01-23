import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermissions();
  Position position = await getPreciseLocation();
  print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
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
  List<String> classrooms = [
    'Math',
    'Science',
    'History',
    'English',
    'Art',
    'Music',
    'Gym',
    'Library',
    'Computer Labdasdasdasdad',
    'Cafeteria',
    'Math',
    'jda',
    'dasdasdasdasdasdad',
    'f',
    'gasdasdasdasdasdasdasdasdasdasdasdakldakldjalkdjaskldjaslkdjaslkdasjdlkajdaskljdkalsjdalkdjaslk',
    'h',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
  List<String> filteredClassrooms = [];

  @override
  void initState() {
    super.initState();
    filteredClassrooms = classrooms;
    controller.addListener(() {
      filterClassrooms();
    });
  }

  void filterClassrooms() {
    List<String> results = [];
    if (controller.text.isEmpty) {
      results = classrooms;
    } else {
      results = classrooms
          .where((classroom) =>
              classroom.toLowerCase().contains(controller.text.toLowerCase()))
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
                                      Compass(
                                          index: index,
                                          filteredClassrooms:
                                              filteredClassrooms),
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
                            child: Align(
                              alignment: Alignment.center,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  filteredClassrooms[index],
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black),
                                ),
                              ),
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

class Compass extends StatefulWidget {
  final int index;
  final List<String> filteredClassrooms;

  Compass({required this.index, required this.filteredClassrooms});

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.filteredClassrooms[widget.index],
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Define the action when the text is clicked
              print('Text clicked');
            },
            child: Text(
              'Se Kort',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Text("data"),
    );
  }
}
