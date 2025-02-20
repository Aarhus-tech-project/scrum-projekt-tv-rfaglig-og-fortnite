import 'package:classroom_finder_app/LoginRegisterPage.dart';
import 'package:classroom_finder_app/ProfilePage.dart';
import 'package:classroom_finder_app/SearchClassroomsPage.dart';
import 'package:classroom_finder_app/Services/Apiservices.dart';
import 'package:classroom_finder_app/SitesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginRegisterPage(),
    ));
  });
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
    ProfilePage(),
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
