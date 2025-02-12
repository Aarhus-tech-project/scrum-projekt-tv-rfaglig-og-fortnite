import 'package:flutter/material.dart';

class SitesPage extends StatelessWidget { 
  final List<String> items = List.generate(5, (index) => "Site ${index + 1}");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ), 
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    items[index],
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}