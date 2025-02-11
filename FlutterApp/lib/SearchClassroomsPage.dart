import 'package:classroom_finder_app/ClassroomCompassPage.dart';
import 'package:classroom_finder_app/Models/Room.dart';
import 'package:classroom_finder_app/Services/Apiservices.dart';
import 'package:flutter/material.dart';

class SearchClassroomsPage extends StatefulWidget {
  const SearchClassroomsPage({super.key});

  @override
  State<SearchClassroomsPage> createState() => _SearchClassroomsPageState();
}

class _SearchClassroomsPageState extends State<SearchClassroomsPage> {
  List<Room> classrooms = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateSearchClassrooms(searchController.text);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  updateSearchClassrooms(String keyword) async {
    List<Room> newClassrooms = await ApiService.searchClassrooms(keyword: keyword);
    setState(() {
      classrooms = newClassrooms;
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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: searchController,
                  onChanged: updateSearchClassrooms,
                  decoration: InputDecoration(
                    hintText: 'Search for Classrooms',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: classrooms.length,
                    itemBuilder: (context, index) {
                      return ClassroomSearchItem(context, index);
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

  Container ClassroomSearchItem(BuildContext context, int index) {
    return Container(
      height: 70,
      margin: EdgeInsets.all(10),
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
                  ClassroomCompassPage(room: classrooms[index]),
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
              classrooms[index].name,
              style: TextStyle(
                  fontSize: 30, color: Colors.black),
            ),
            Text("10m",
                style: TextStyle(
                    fontSize: 30, color: Colors.black)),
          ],
        ),
      )
    );
  }
}