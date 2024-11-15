import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import for secure storage
import 'package:challange_kide/services/api_service.dart'; // Ensure this import is valid
import 'favorite.dart'; // Import for the SignInScreen

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _selectedGender;
  String? _selectedEducationLevel;
  final List<String> _educationLevels = [
    '1 year primary school',
    '2 year primary school',
    '3 year primary school',
    '4 year primary school',
    '5 year primary school',
    '6 year primary school'
  ];
  bool _isSignUpClicked = false;

  final ApiService _apiService = ApiService(); // Initialize your API service
  final FlutterSecureStorage _storage = FlutterSecureStorage(); // Initialize secure storage

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')), // Add a title for clarity
      body: SingleChildScrollView(
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
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10),
                          const Text(
                            'Welcome! Please fill in the information below.',
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
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: Colors.blueGrey),
                                    hintText: 'Enter your email',
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
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _birthdayController,
                                  decoration: InputDecoration(
                                    labelText: 'Birthday',
                                    labelStyle: TextStyle(color: Colors.blueGrey),
                                    hintText: 'Enter your birthday',
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
                                      return 'Please enter your birthday';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  readOnly: true,
                                ),
                                SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  value: _selectedEducationLevel,
                                  hint: Text('Select your education level'),
                                  items: _educationLevels.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedEducationLevel = newValue;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Education Level',
                                    labelStyle: TextStyle(color: Colors.blueGrey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select your education level';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                // Gender section centered
                                // Gender section centered
Center(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Gender',
        style: TextStyle(color: Colors.blueGrey),
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio<String>(
            value: 'Male',
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          Text('Male'),
          SizedBox(width: 20),
          Radio<String>(
            value: 'Female',
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          Text('Female'),
          SizedBox(width: 20),
        ],
      ),
      if (_isSignUpClicked && _selectedGender == null)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Please select your gender',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
    ],
  ),
),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // Retrieve the data
                                      // Retrieve the data
String username = _usernameController.text;
String email = _emailController.text;
String password = _passwordController.text;
String birthday = _birthdayController.text;
String gender = _selectedGender ?? ''; // Default to empty string if null

// Check gender selection
if (_selectedGender == null) {
  setState(() {
    _isSignUpClicked = true;
  });
  return;
}

try {
  // Call the register method
  bool success = await _apiService.register(username, email, password, gender, birthday);
  print('success test test: ${success}');
  if (success) {
    // Store a flag indicating successful registration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign Up Successful')),
    );
    bool success = await _apiService.login(email, password);
    await _storage.write(key: 'loggedIn', value: 'true');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => favoriteScreen()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration Failed')),
    );
  }
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}

                                    } else {
                                      setState(() {
                                        _isSignUpClicked = true;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Sign Up',
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
      ),
    );
  }
}
