import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Auth_Service/Auth_service_Screen.dart';
import '../Parent_pages/Parent_home_screen.dart';
import '../child_pages/First_page.dart';
import '../psychiatrist_pages/psychiatrist_Home_Page.dart';
import 'Forget_password_page.dart';
import 'Registration_Screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String _errorMessage = '';
  bool _obscurePassword = true;
  String? _selectedRole;
  bool _isLoading = false;

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_selectedRole == null) {
      setState(() {
        _errorMessage = 'Please select a role.';
      });
      return;
    }

    try {
      User? user = await _authService.loginUser(email, password);
      if (user == null) {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
        });
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        setState(() {
          _errorMessage = 'User not found in the database.';
        });
        return;
      }

      final Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      print("User Data: $userData"); // Debugging output

      if (userData == null || !userData.containsKey('role') ||
          (!userData.containsKey('username') && !userData.containsKey('name'))) {
        setState(() {
          _errorMessage = 'Incomplete user data. Please contact support.';
        });
        return;
      }

      // Convert age
      final age = userData['age'] is int
          ? userData['age'] as int
          : int.tryParse(userData['age']?.toString() ?? '') ?? 0;



      String role = userData['role'] as String;
      String username = userData['username'] ?? userData['name'] ?? ''; // Fallback to 'name' for child users


      if (role.toLowerCase() != _selectedRole!.toLowerCase()) {
        setState(() {
          _errorMessage = 'Role mismatch. Please select the correct role.';
        });
        return;
      }


      switch (role.toLowerCase()) {
        case 'parent':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ParentHomeScreen(
                userName: username,
                parentEmail: email,
              ),
            ),
          );
          break;
        case 'child':
          final String uid = user.uid; // Get the user ID from FirebaseAuth
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChildHomePage(
                userName: username,
                userId: uid, // Pass the UID here
              ),
            ),
          );
          break;
        case 'psychiatrist':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PsychiatristHomePage(
                userName: username,
              ),
            ),
          );
          break;
        default:
          setState(() {
            _errorMessage = 'Unknown role. Please contact support.';
          });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
      print('Login error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFFDFAF7),
      appBar: AppBar(
        backgroundColor: Color(0xFF5c724a),
        elevation: 0,
        title: Text('Login', style: TextStyle(color: Color(0xFFfaf0e6))),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5c724a),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Log in to continue to your account',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                          value: 'Parent',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        Text('Parent'),
                        SizedBox(width: 20),
                        Radio<String>(
                          value: 'Child',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        Text('Child'),
                        SizedBox(width: 20),
                        Radio<String>(
                          value: 'Psychiatrist',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        Text('Psychiatrist'),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Color(0xFF5c724a)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF5c724a)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color:Color(0xFF5c724a),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,  // Align "Forget Password" button to the right
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    "Forget Password",
                    style: TextStyle(color: Color(0xFF5c724a), fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.8, 50),
                  backgroundColor: Color(0xFF5c724a),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Color(0xFF5c724a), fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

