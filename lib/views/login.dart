// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:washifyy/customs/customtextfield.dart';
import 'package:washifyy/customs/squaretile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true; // Initial state for text visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
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
                SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: _obscureText, // Pass the visibility state
                  suffixIcon: _obscureText
                      ? Icons.visibility
                      : Icons
                          .visibility_off, // Change the icon based on visibility state
                  onSuffixIconPressed:
                      _togglePasswordVisibility, // Toggle visibility on icon press
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
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
                ElevatedButton(onPressed: _login, child: Text("Login")),
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style:
                          TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
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
      final String apiUrl = 'http://127.0.0.1:8000/customers/login/';

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
          final Map<String, dynamic> responseData = json.decode(response.body);
          var userId = responseData['user_id'];
          var username = responseData['username'];

          print('user id $userId');
          print("username $username");
          await saveUserData(userId, username);
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

  Future<void> saveUserData(int userId, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString('username', username);
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  bool _isValidEmail(String email) {
    // validation using RegExp
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
