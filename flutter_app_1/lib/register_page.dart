import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart'; // Import HomePage

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    final String userName = _usernameController.text;
    final String password = _passwordController.text;
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    final String email = _emailController.text;

    final checkEmailUrl = Uri.parse('http://10.0.2.2:5000/check_email'); // Replace with your Flask backend URL
    final registerUrl = Uri.parse('http://10.0.2.2:5000/register'); // Replace with your Flask backend URL

    try {
      // Check if email exists
      final checkEmailResponse = await http.post(
        checkEmailUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      final emailResponseJson = json.decode(checkEmailResponse.body);

      if (checkEmailResponse.statusCode == 200 && emailResponseJson['exists']) {
        // Email already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email address already exists')),
        );
      } else {
        // Proceed with registration
        final response = await http.post(
          registerUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': userName, // 'username' should match the key expected in Flask
            'password': password,
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
          }),
        );

        if (response.statusCode == 200) {
          // Navigate to HomePage if registration is successful
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(username: userName), // Pass the username to HomePage
            ),
          );
        } else {
          // Handle registration failure
          print('Registration failed: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed')),
          );
        }
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred during registration')),
      );
    }
  }


  void _resetForm() {
    _usernameController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text('Register'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetForm,
              child: Text('Reset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
