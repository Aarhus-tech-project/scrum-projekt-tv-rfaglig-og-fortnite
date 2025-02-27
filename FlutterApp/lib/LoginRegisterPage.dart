import 'package:classroom_finder_app/main.dart';
import 'package:flutter/material.dart';
import 'package:classroom_finder_app/Services/ApiServices.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loginToggle = true;

  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                    child: LoginRegisterToggle(),
                  ),
                  SizedBox(height: 50.0),
                  InputFields(),
                  SizedBox(height: 70.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
                    child: loginToggle
                        ? AuthButton(
                            text: "Login",
                            onPressed: () async {
                              try {
                                await ApiService.login(emailController.text,
                                    passwordController.text);
                                showSnackBar("Login Successful!", Colors.green);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainPage()));
                              } catch (e) {
                                showSnackBar(e.toString(), Colors.red);
                              }
                            })
                        : AuthButton(
                            text: "Register",
                            onPressed: () async {
                              try {
                                await ApiService.register(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text);
                                showSnackBar(
                                    "Registration Successful!", Colors.green);
                              } catch (e) {
                                showSnackBar(e.toString(), Colors.red);
                              }
                            }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column InputFields() {
    return Column(
      children: [
        if (!loginToggle)
          AuthTextField(
            controller: nameController,
            labelText: "Name",
            icon: Icons.person,
            hintText: "Enter your Name",
          ),
        AuthTextField(
          controller: emailController,
          labelText: "Email",
          icon: Icons.email,
          hintText: "Enter your email",
        ),
        AuthTextField(
          controller: passwordController,
          labelText: "Password",
          icon: Icons.lock,
          hintText: "Enter your password",
          obscureText: true,
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
                  color: loginToggle ? Colors.blue : Colors.grey,
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
                    loginToggle = true;
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
                color: loginToggle ? Colors.grey : Colors.blue,
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
                    loginToggle = false;
                  });
                },
                child: Text('Register',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 33, 150, 243),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final String hintText;
  final bool obscureText;

  const AuthTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            icon: Icon(icon),
            hintText: hintText,
          ),
          obscureText: obscureText,
        ),
      ),
    );
  }
}
