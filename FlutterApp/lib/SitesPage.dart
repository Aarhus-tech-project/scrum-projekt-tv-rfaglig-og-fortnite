import 'package:classroom_finder_app/ClassroomCompassPage.dart';
import 'package:classroom_finder_app/Models/Site.dart';
import 'package:classroom_finder_app/Services/Apiservices.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SitesPage extends StatefulWidget { 
  @override
  State<SitesPage> createState() => _SitesPageState();
}

class _SitesPageState extends State<SitesPage> {
  List<Site> mySites = [];
  List<Site> nearbySites = [];

  @override
  void initState() {
    super.initState();
    updateSites();
  }

  updateSites() async {
    try {
      var newMySites = await ApiService.getUserSites();

      Position position = await LocationUtils.getPreciseLocation();
      //var newNearbySites = await ApiService.getNearbySites(lat: position.latitude, lon: position.longitude);
      setState(() {
        mySites = newMySites;
        nearbySites = newMySites;
      });
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(backgroundColor: const Color.fromARGB(255, 96, 154, 253), child: Icon(Icons.add, color: Colors.white,), onPressed: () {}),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('My Sites', style: TextStyle(fontSize: 24),),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                  ), 
                  itemCount: mySites.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Colors.blueAccent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mySites[index].name,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              '${mySites[index].roomCount.toString()} Room(s)',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                  },
                ),
              ),
              Divider(thickness: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Nearby Sites', style: TextStyle(fontSize: 24),),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                  ), 
                  itemCount: nearbySites.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text(
                            nearbySites[index].name,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}