import 'package:classroom_finder_app/DistanceClass.dart';
import 'package:flutter/material.dart';

class Compass extends StatefulWidget {
  final RoomLocation Room;
  Compass({required this.Room});

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
                child: Icon(
                  Icons.arrow_upward_rounded,
                  size: MediaQuery.of(context).size.width - 80,
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
              "Afstand 10m",
              style:
                  TextStyle(fontSize: 30, decoration: TextDecoration.underline),
            ),
            Text("Etage 1", style: TextStyle(fontSize: 30))
          ],
        )));
  }
}
