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
  List<String> items = [
    'Classroom 1', // First item
    'Classroom 2', // Second item
    'Classroom 3', // Third item
  ];

  final TextEditingController controller = TextEditingController();

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
                    itemCount: 3, // Number of items in the list
                    itemBuilder: (context, index) {
                      // Define the items in the list

                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller.text = items[index];
                          });
                        },
                        child: Container(
                          height: 50,
                          child: Center(child: Text(items[index])),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          height: 100,
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.only(left: 25, right: 25, bottom: 8),
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.red,
              child: Text("click", style: TextStyle(fontSize: 30)),
            ),
          ),
        ),
      ),
    );
  }
}
