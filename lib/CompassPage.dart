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
        body: Column(
          children: [
            Container(
              color: Colors.grey,
              width: double.infinity,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text("Lokale AS106"), Text("Etage 3")],
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
              style: TextStyle(fontSize: 30),
            ),
            Text("Etage 1", style: TextStyle(fontSize: 30))
          ],
        )));
  }
}
