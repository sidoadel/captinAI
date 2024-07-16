import 'package:flutter/material.dart';
import 'package:captinai/api_service.dart';
import 'package:captinai/user_roles.dart';
import 'package:captinai/screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _selectedRole;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        var response = await apiService.signup(_email, _password, _selectedRole!);
        if (response['message'] == 'User created successfully') {
          // Navigate to home screen with selected role
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(role: _selectedRole!)),
          );
          _showSnackBar('Signup successful');
        } else {
          _showSnackBar(response['message']);
        }
      } catch (e) {
        _showSnackBar('Error signing up: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                onChanged: (String? value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                items: [
                  UserRoles.headCoach,
                  UserRoles.coach,
                  UserRoles.youthAcademyCoach,
                  UserRoles.player,
                  UserRoles.youthPlayer,
                ].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
