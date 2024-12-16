import 'package:flutter/material.dart';
import '../main_shape_file.dart'; // Import the shape guessing screen

class ShapeSplashScreen extends StatefulWidget {
  @override
  _ShapeSplashScreenState createState() => _ShapeSplashScreenState();
}

class _ShapeSplashScreenState extends State<ShapeSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.asset(
              'assets/kids/games/shapes_background.gif',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground UI Elements
          Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Color(0xFF9AD0EC).withOpacity(0.8), // Semi-transparent background for text readability
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Guess the Shape',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Test your shape recognition skills! '
                        'You will be shown different shapes, and you must correctly identify them. '
                        'Challenge yourself and see how many shapes you can guess correctly!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShapeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button background color
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Adjust the padding for size
                      textStyle: TextStyle(
                        fontSize: 18, // Adjust font size as needed
                      ),
                    ),
                    child: Text(
                      'Start',
                      style: TextStyle(color: Color(0xFF5B6D5B)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Custom Positioned Back Button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
