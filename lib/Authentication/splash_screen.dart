import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to LoginScreen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFAF7), // Beige background color
      body: Center(
        child: Stack(
          alignment: Alignment.center, // Align text in the center of the GIF
          children: [
            // Centered GIF
            Container(
              width: 350, // Adjust width of the GIF
              height: 350, // Adjust height of the GIF
              child: Image.asset(
                'assets/splash_gif.gif', // Replace with your actual GIF path
                fit: BoxFit.contain,
              ),
            ),
            // Centered "MathMind" text
            Text(
              'MathMind',
              style: TextStyle(
                fontSize: 40, // Font size for the title
                fontWeight: FontWeight.bold,
                color: Color(0xFFFDFAF7), // White text for contrast on GIF
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.5), // Add shadow for better visibility
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
