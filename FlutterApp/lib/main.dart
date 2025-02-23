import 'package:classroom_finder_app/AddSitePage.dart';
import 'package:classroom_finder_app/LoginRegisterPage.dart';
import 'package:classroom_finder_app/Models/AddEditSiteDTO.dart';
import 'package:classroom_finder_app/SearchClassroomsPage.dart';
import 'package:classroom_finder_app/Services/Apiservices.dart';
import 'package:classroom_finder_app/SitesPage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginRegisterPage(),
  ));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    SitesPage(),
    SearchClassroomsPage(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    ApiService.setLogoutHandler(() {
      print("Logging out...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginRegisterPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work),
            label: 'Sites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Page', style: TextStyle(fontSize: 24)));
  }
}