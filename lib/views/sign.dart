// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:washifyy/configs/constants.dart';
import 'package:washifyy/customs/custombutton.dart';
import 'package:washifyy/customs/customtextfield.dart';
import 'package:washifyy/customs/squaretile.dart';
import 'package:http/http.dart' as http;

class Sign extends StatefulWidget {
  Sign({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<Sign> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  void _togglePasswordVisibility(int fieldNumber) {
    setState(() {
      if (fieldNumber == 1) {
        _obscureText1 = !_obscureText1;
      } else {
        _obscureText2 = !_obscureText2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 0),
                  Image.asset(
                    'assets/logo.png',
                    height: 90,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    "Welcome!!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 0),
                  CustomTextField(
                      controller: usernameController,
                      hintText: 'John Doe',
                      suffixIcon: null,
                      prefixIcon: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      }),
                  SizedBox(height: 0),
                  CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      suffixIcon: null,
                      prefixIcon: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!_isValidEmail(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      }),
                  SizedBox(height: 0),
                  CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: _obscureText1,
                      suffixIcon: _obscureText1
                          ? Icons.visibility
                          : Icons.visibility_off,
                      onSuffixIconPressed: () {
                        _togglePasswordVisibility(1);
                      },
                      prefixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }

                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password must contain at least one lowercase letter';
                        }

                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          return 'Password must contain at least one special character';
                        }
                        return null;
                      }),
                  SizedBox(height: 0),
                  CustomTextField(
                      controller: password2Controller,
                      hintText: 'Confirm Password',
                      obscureText: _obscureText2,
                      suffixIcon: _obscureText2
                          ? Icons.visibility
                          : Icons.visibility_off,
                      onSuffixIconPressed: () {
                        _togglePasswordVisibility(2);
                      },
                      prefixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      }),
                  SizedBox(height: 00),
                  ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: Text('Login')),
                  SizedBox(height: 0),
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
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Or Continue with',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        SizedBox(
                          width: 10,
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
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Squaretile(
                        imagePath: 'assets/apple.png',
                        height: 40,
                      ),
                      SizedBox(width: 20),
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
                        'Already a member?',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateToLogin();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateToHome() {
    Get.offNamed('/home');
  }

  void navigateToLogin() {
    Get.toNamed('/login');
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String username = usernameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;

      Map<String, dynamic> userData = {
        'username': username,
        'email': email,
        'password': password,
      };

      // Convert the data to JSON
      String jsonData = jsonEncode(userData);

      // Convert your backend API URL string to a Uri object
      var apiUrl = Uri.parse("http://127.0.0.1:8000/customers/signup/");

      // Make a POST request to your Django backend API
      try {
        final response = await http.post(
          apiUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );

        // if the request is successful
        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text('Account created successfully')),
              );
            },
          );

          // Delay navigation to dashboard by 2 seconds (adjust as needed)
          await Future.delayed(Duration(seconds: 1));
          navigateToHome();
        } else {
          // Handle other status codes (e.g., display error message)
          print('Failed to register: ${response.body}');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text('Registration Failed')),
                content: Text('User with this email already exists.'),
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
        print('Error registering user: $error');
      }
    }
  }

  bool _isValidEmail(String email) {
    // validation using RegExp
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
