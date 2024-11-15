import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import the secure storage package
import 'signUp.dart';
import 'home.dart';
import 'package:challange_kide/services/api_service.dart'; // Import ApiService

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService(); // Create an instance of ApiService
  final FlutterSecureStorage _storage = FlutterSecureStorage(); // Create an instance of secure storage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0), // Background color
      ),
      body: FutureBuilder<bool>(
        future: _isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == true) {
            // User is logged in, navigate to HomeScreen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            });
            return Container(); // Return an empty container while navigating
          }

          // User is not logged in, show the sign-in screen
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Logo
                        Image.asset(
                          'image/kids.png', // Path to your logo asset
                          height: 200, // Adjust the height of the logo
                        ),
                        SizedBox(height: 30),
                        // Container wrapping the form
                        Container(
                          padding: EdgeInsets.all(16.0), // Padding inside the container
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color of the container
                            borderRadius: BorderRadius.circular(12.0), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 10),
                              const Text(
                                'Welcome back! Nice to see you again.',
                                style: TextStyle(fontSize: 16), // Style for welcome text
                              ),
                              SizedBox(height: 20), // Space between welcome text and form
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        labelStyle: TextStyle(color: Colors.blueGrey),
                                        hintText: 'Enter your username',
                                        hintStyle: TextStyle(color: Colors.grey[600]),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your username';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: TextStyle(color: Colors.blueGrey),
                                        hintText: 'Enter your password',
                                        hintStyle: TextStyle(color: Colors.grey[600]),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                        ),
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    TextButton(
                                      onPressed: () {
                                        // Handle forgot password action
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Forgot Password Clicked')),
                                        );
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Colors.blue, // Text color
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          // Retrieve the username and password
                                          String email = _usernameController.text;
                                          String password = _passwordController.text;

                                          try {
                                            // Call the login method
                                            bool success = await _apiService.login(email, password);
                                            if (success) {
                                              // Store a flag indicating successful login
                                              await _storage.write(key: 'loggedIn', value: 'true');
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Login Successful')),
                                              );
                                              // Navigate to HomeScreen
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => HomeScreen()),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Invalid Credentials')),
                                              );
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Error: $e')),
                                            );
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(61,143, 239, 1), // Background color
                                        foregroundColor: Colors.white, // Text color
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 140), // Adjusted padding
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0), // Rounded corners
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                                        );
                                      },
                                      child: Text(
                                        "I don't have an account? Sign Up",
                                        style: TextStyle(
                                          color: Colors.blue, // Text color
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _isUserLoggedIn() async {
    // Check if the user is logged in by reading the value from secure storage
    String? loggedIn = await _storage.read(key: 'loggedIn');
    return loggedIn == 'true';
  }
}
