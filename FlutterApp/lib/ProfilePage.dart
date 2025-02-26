import 'dart:convert';
import 'dart:developer';

import 'package:classroom_finder_app/Services/ApiKeyService.dart';
import 'package:classroom_finder_app/Services/ApiKeyStorageService.dart';
import 'package:flutter/material.dart';
import 'package:classroom_finder_app/Services/Apiservices.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userInfo;
  String? userName;

  @override
  void initState() {
    super.initState();
    user();
  }

  void deleteUser() async {
    try {
      String? apiKey = await ApiKeyStorageService.getApiToken();
      ApiService.deleteUser(apiKey!);
    } catch (e) {
      print('error');
    }
  }

  void user() async {
    String? apiKey = await ApiKeyStorageService.getApiToken();

    userInfo = Apikeyservice.validateApiKey(apiKey);
    if (userInfo != null && userInfo!['sub'] != null) {
      Map<String, dynamic> subData = userInfo!['sub'];
      setState(() {
        userName = subData['Name'];
      });
    }
  }

  @override
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
                child: Column(
                  children: [
                    Text(userName ?? 'Loading...'),
                  ],
                ),
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
              ElevatedButton(
                onPressed: () async {
                  deleteUser();
                  ApiService.onLogout?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 186, 31, 20), // Set the background color to red
                ),
                child: Text(
                  'Delete Account',
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
