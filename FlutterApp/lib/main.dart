import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'LoginRegisterPage.dart';
import 'SitesPage.dart';
import 'ProfilePage.dart';
import 'SearchClassroomsPage.dart';
import 'Services/ApiKeyStorageService.dart';
import 'Services/ApiKeyService.dart';
import 'Services/ApiServices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _isAuthenticated;

  @override
  void initState() {
    super.initState();
    _isAuthenticated = checkAuth();
  }

  Future<bool> checkAuth() async {
    String? apiKey = await ApiKeyStorageService.getApiToken();
    bool isValid = Apikeyservice.validateApiKey(apiKey)['isValid'] == true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: _isAuthenticated,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasData && snapshot.data == true) {
                  return MainPage();
                } else {
                  return LoginRegisterPage();
                }
              },
            ),
        '/main': (context) => MainPage(),
        '/login': (context) => LoginRegisterPage(),
      },
    );
  }
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
      if (!mounted) return; // ✅ Prevent async navigation issue
      print("Logging out...");
      Navigator.pushReplacementNamed(context, '/login');
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
