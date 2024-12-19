import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'car_result_screen.dart';

class CarGameScreen extends StatefulWidget {
  @override
  _CarGameScreenState createState() => _CarGameScreenState();
}

class _CarGameScreenState extends State<CarGameScreen> {
  double carX = 0.0; // Car position (horizontal)
  double carY = 0.8; // Fixed vertical position
  double objectX = Random().nextDouble() * 2 - 1; // Random x-position for the object
  double objectY = -1.0; // Initial y-position for the object
  int score = 0; // Game score
  int timer = 30; // Game timer in seconds
  bool isGameOver = false;
  Timer? gameTimer;

  void startGame() {
    // Move objects down and handle collisions
    gameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        objectY += 0.02; // Slower falling speed
        if (objectY >= 1.0) {
          // Object reached the bottom of the screen
          objectY = -1.0;
          objectX = Random().nextDouble() * 2 - 1; // Reset object position
        }

        if (objectY >= carY - 0.1 &&
            (objectX - carX).abs() <= 0.2) {
          // Collision detection
          score += Random().nextInt(9) + 1; // Random score between 1-9
          objectY = -1.0;
          objectX = Random().nextDouble() * 2 - 1; // Reset object position
        }
      });
    });

    // Timer countdown
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick >= 30) {
        setState(() {
          isGameOver = true;
        });
        timer.cancel();
        gameTimer?.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CarResultScreen(score: score,),
          ),
        );
      } else {
        setState(() {
          this.timer -= 1;
        });
      }
    });
  }

  void moveCar(double direction) {
    setState(() {
      carX += direction;
      carX = carX.clamp(-1.0, 1.0); // Keep the car within the screen
    });
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      backgroundColor: Color(0xFFFDFAF7),
      body: Stack(
        children: [
          // Timer and Score
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              "Time: $timer",
              style: TextStyle(fontSize: 24, color: Colors.blueAccent),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Text(
              "Score: $score",
              style: TextStyle(fontSize: 24, color: Colors.blueAccent),
            ),
          ),

          // Falling Object
          Positioned(
            top: MediaQuery.of(context).size.height * objectY,
            left: (MediaQuery.of(context).size.width / 2) * objectX +
                MediaQuery.of(context).size.width / 2 -
                20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  "${Random().nextInt(9) + 1}",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),

          // Car Object
          Positioned(
            bottom: MediaQuery.of(context).size.height * (1 - carY) - 40,
            left: (MediaQuery.of(context).size.width / 2) * carX +
                MediaQuery.of(context).size.width / 2 - 40,
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                'assets/games/car_play.png', // Replace with your image path
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Controls
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () => moveCar(-0.1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: CircleBorder(),
                padding: EdgeInsets.all(16),
              ),
              child: Icon(Icons.arrow_left, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () => moveCar(0.1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: CircleBorder(),
                padding: EdgeInsets.all(16),
              ),
              child: Icon(Icons.arrow_right, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
