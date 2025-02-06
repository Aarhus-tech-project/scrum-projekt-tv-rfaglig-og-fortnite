import 'package:classroom_finder_app/RoomLocation.dart';
import 'package:flutter/material.dart';

class Map extends StatefulWidget {
  final RoomLocation Room;
  const Map({super.key, required this.Room});

  @override
  State<Map> createState() => _Map();
}

class _Map extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Room.name),
      ),
      body: Center(
        child: Text('Hello, world!'),
      ),
    );
  }
}

class $ {}
