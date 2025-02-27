import 'package:classroom_finder_app/ClassroomCompassPage.dart';
import 'package:classroom_finder_app/Models/Room.dart';
import 'package:classroom_finder_app/Services/ApiServices.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SearchClassroomsPage extends StatefulWidget {
  const SearchClassroomsPage({super.key});

  @override
  State<SearchClassroomsPage> createState() => _SearchClassroomsPageState();
}

class _SearchClassroomsPageState extends State<SearchClassroomsPage> {
  List<Room> rooms = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    updateSearchClassrooms(searchController.text);
  }

  late double userLatitude = 0.0;
  late double userLongitude = 0.0;

  Future<void> _getUserLocation() async {
    Position userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      userLatitude = userPosition.latitude;
      userLongitude = userPosition.longitude;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  updateSearchClassrooms(String keyword) async {
    List<Room> newClassrooms =
        await ApiService.searchClassrooms(keyword: keyword);
    _getUserLocation();
    setState(() {
      rooms = newClassrooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: updateSearchClassrooms,
                    decoration: InputDecoration(
                      hintText: 'Search Rooms',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return ClassroomSearchItem(context, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding ClassroomSearchItem(BuildContext context, int index) {
    double distance = Geolocator.distanceBetween(
      userLatitude,
      userLongitude,
      rooms[index].latitude,
      rooms[index].longitude,
    );

    String distanceText;
    if (distance >= 1000) {
      distanceText = "${(distance / 1000).toStringAsFixed(1)}km";
    } else {
      distanceText = "${distance.toStringAsFixed(0)}m";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ClassroomCompassPage(room: rooms[index]),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.room,
                size: 25,
                color: Colors.black,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        rooms[index].name,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        rooms[index].siteName,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                distanceText,
                style: TextStyle(fontSize: 20, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
