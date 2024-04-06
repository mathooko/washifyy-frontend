// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:washifyy/configs/constants.dart';
import 'package:washifyy/customs/custombutton.dart';
import 'package:washifyy/customs/customtextfield.dart';
import 'package:washifyy/customs/squaretile.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  void _visibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/logo.png',
                  height: 90,
                  color: Colors.deepPurple,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome back!!",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    suffixIcon: Icon(null),
                    prefixIcon: Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!_isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    }),
                SizedBox(height: 20),
                CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    suffixIcon: Icon(null),
                    prefixIcon: Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    }),
                SizedBox(height: 20),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                CustomButton(
                  onTap: () {
                    navigateToHome();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or Continue with',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Squaretile(
                      imagePath: 'assets/apple.png',
                      height: 40,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Squaretile(
                      imagePath: 'assets/google.png',
                      height: 30,
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigateToSignup();
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToHome() {
    Get.offNamed('/home');
  }

  void navigateToSignup() {
    Get.toNamed("/sign");
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final String email = emailController.text;
      final String password = passwordController.text;

      // Your login API endpoint URL
      final String apiUrl = 'http://10.0.2.2:8000/customers/login/';

      // Prepare the login data
      final Map<String, dynamic> loginData = {
        'email': email,
        'password': password,
      };

      // Convert login data to JSON
      final String jsonData = jsonEncode(loginData);

      try {
        // Make POST request to login endpoint
        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );

        //  ifis successful
        if (response.statusCode == 200) {
          navigateToHome();
        } else {
          print('Failed to login: ${response.body}');
          // Display error message to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text('Login Failed')),
                content: Text('Please check your credentials and try again.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        // Handle errors (e.g., connection error)
        // For example:
        print('Error logging in: $error');
        // Display error message to the user
        // showDialog(...);
      }
    }
  }

  bool _isValidEmail(String email) {
    // validation using RegExp
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
