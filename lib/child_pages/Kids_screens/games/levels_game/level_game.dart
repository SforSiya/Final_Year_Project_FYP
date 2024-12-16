import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'new_game/game_page1.dart';


class SplashScreen_lvl extends StatefulWidget {
  @override
  _SplashScreen_lvlState createState() => _SplashScreen_lvlState();
}

class _SplashScreen_lvlState extends State<SplashScreen_lvl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the app bar background transparent
        elevation: 0, // Remove shadow below the app bar
        leading: BackButton(
          color: Colors.black, // Set back button color to black
        ),
      ),
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.asset(
              'assets/games/butterfly.gif',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground UI Elements
          Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Color(0xFFD3E4CD).withOpacity(0.8), // Semi-transparent background for text readability
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
                        MaterialPageRoute(builder: (context) => MonsterMathGame()),
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
        ],
      ),
    );
  }
}
