import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

Future<void> sendData(String name, String email, String password) async {
  final url = Uri.parse('http://10.0.2.2:5126/api/auth/Register');

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    print('Success: ${response.body}');
  } else {
    throw Exception('Failed to send data');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String Name = 'Nillersssasdasdssss';
  String Email = 'nillersssssasdasdssss@gmail.com';
  String Password = '1234sssasdasdssss';
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LoginRegisterToggle(),
              InputFields(),
              light ? LoginButton() : RegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Container LoginButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          // Add your login logic here
        },
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container RegisterButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          sendData(Name, Email, Password);
        },
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Column InputFields() {
    return Column(
      children: [
        light
            ? Container()
            : Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: InputBorder.none,
                      icon: Icon(Icons.person),
                      hintText: 'Enter your Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        Name = value;
                      });
                    },
                  ),
                ),
              ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 60,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: InputBorder.none,
                icon: Icon(Icons.email),
                hintText: 'Enter your email',
              ),
              onChanged: (value) {
                setState(() {
                  Email = value;
                });
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 60,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: InputBorder.none,
                icon: Icon(Icons.lock),
                hintText: 'Enter your password',
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  Password = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  SizedBox LoginRegisterToggle() {
    return SizedBox(
      height: 80.0,
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 3),
                        blurRadius: 6,
                        spreadRadius: -3),
                  ],
                  color: light ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                onPressed: () {
                  setState(() {
                    light = true;
                  });
                },
                child: Text('Login',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: light ? Colors.grey : Colors.blue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                onPressed: () {
                  setState(() {
                    light = false;
                  });
                },
                child: Text('SignUp',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
