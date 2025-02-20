import 'package:flutter/material.dart';
import 'package:classroom_finder_app/Services/Apiservices.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final data = await ApiService.fetchUserData();
    setState(() {
      userData = data;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Icon(Icons.person, size: 200, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 24, decoration: TextDecoration.underline),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(style: TextStyle(fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: () {
                  ApiService.onLogout?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 186, 31, 20), // Set the background color to red
                ),
                child: Text(
                  'Log out',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
