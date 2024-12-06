
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Utility function to show toast/snackbar messages
  void _showMessage(String message, {Color color = Colors.green}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Function to send the password reset email
  Future<void> _sendPasswordResetEmail() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email.', color: Colors.red);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage(
          'We have sent you an email to recover your password. Please check your inbox.');
    } catch (e) {
      _showMessage('Error: ${e.toString()}', color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.green[400],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[400],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.email, color: Colors.green[400]),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Send Reset Link',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/*import 'dart:async'; // For Timer
import 'dart:math'; // For generating a random OTP
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'OTP_Verification_page.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _message = '';
  String? _otp; // Current OTP
  Timer? _timer;
  int _secondsRemaining = 59; // Timer duration in seconds
  bool _isResendAvailable = false; // Resend button availability

  /// Function to generate a 6-digit random OTP
  String _generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit OTP
  }

  /// Start the 59-second countdown
  void _startTimer() {
    setState(() {
      _secondsRemaining = 59;
      _isResendAvailable = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isResendAvailable = true;
          _timer?.cancel();
        }
      });
    });
  }

  /// Send OTP to email
  Future<void> _sendOTP() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _message = 'Please enter your email.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // Generate new OTP
      _otp = _generateOTP();

      // Simulate sending an OTP email (replace with your backend logic)
      print('OTP for $email: $_otp'); // Debugging purpose

      setState(() {
        _isLoading = false;
        _message = 'OTP sent to your email! Please check your inbox.';
      });

      // Start the timer
      _startTimer();

      // Navigate to OTPVerificationScreen with email and OTP
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(email: email, otp: _otp!),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = 'Error: ${e.toString()}';
      });
    }
  }

  /// Handle "Resend OTP" button click
  void _resendOTP() {
    if (_isResendAvailable) {
      _sendOTP(); // Resend OTP
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 0,
        title: Text('Forgot Password', style: TextStyle(color: Colors.white)),
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
                'Reset your password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[400],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enter your email to receive an OTP for password reset.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.green[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _sendOTP,
                style: ElevatedButton.styleFrom(
                  minimumSize:
                  Size(MediaQuery.of(context).size.width * 0.8, 50),
                  backgroundColor: Colors.green[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              if (!_isResendAvailable)
                Text(
                  'Resend available in $_secondsRemaining seconds',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              if (_isResendAvailable)
                ElevatedButton(
                  onPressed: _resendOTP,
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                    Size(MediaQuery.of(context).size.width * 0.8, 50),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              SizedBox(height: 20),
              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _message,
                    style: TextStyle(
                      color:
                      _message.contains('Error') ? Colors.red : Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}*/
