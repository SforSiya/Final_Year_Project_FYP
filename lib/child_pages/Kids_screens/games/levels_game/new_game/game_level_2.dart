import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart'; // To lock orientation if needed
import 'game_level_3.dart';

class DotCountingGame extends StatefulWidget {
  @override
  _DotCountingGameState createState() => _DotCountingGameState();
}

class _DotCountingGameState extends State<DotCountingGame> {
  int numberOfIcons = 0;
  TextEditingController answerController = TextEditingController();
  List<String> iconPaths = [
    'assets/images/rb_ball.png',   // Paths to your child-friendly icons
    'assets/images/rb_star.png',
    'assets/images/flower_rb.png',
    'assets/images/elephant_rb.png',
    'assets/images/cat_rb.png',
  ];

  @override
  void initState() {
    super.initState();
    _generateRandomIcons(); // Generate icons when the game starts
  }

  void _generateRandomIcons() {
    final random = Random();
    setState(() {
      numberOfIcons = random.nextInt(10) + 1; // Random number of icons between 1 and 10
    });
  }

  void _checkAnswer() {
    int userAnswer = int.tryParse(answerController.text) ?? -1;
    if (userAnswer == numberOfIcons) {
      _showResultDialog(true); // Show "Well done" if the answer is correct
    } else {
      _showResultDialog(false); // Show "Retry" if the answer is incorrect
    }
  }

  void _showResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isCorrect ? 'Well done! Congratulations!' : 'Wrong answer, try again!',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05, // Adaptive font size based on screen width
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (isCorrect)
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: screenWidth * 0.1, // Icon size adjusted with screen width
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Next', style: TextStyle(fontSize: screenWidth * 0.045)),
              onPressed: () {
                Navigator.of(context).pop();
                if (isCorrect) {
                  _navigateToNextPage(); // Navigate to the next page if correct
                } else {
                  _generateRandomIcons(); // Generate new icons if wrong
                  answerController.clear(); // Clear the answer field
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MathGame()), // Replace MathGame() with your next game class
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Add GIF background
          Positioned.fill(
            child: Image.asset(
              'assets/level_2_background.gif', // Path to your background GIF
              fit: BoxFit.cover, // Ensures the GIF covers the entire background
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Count the icons!',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    shadows: [
                      Shadow( // Add text shadow to make text stand out
                        offset: Offset(1.5, 1.5),
                        blurRadius: 3.0,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Generate fun icons
                Wrap(
                  children: List.generate(numberOfIcons, (index) {
                    final randomIcon = iconPaths[Random().nextInt(iconPaths.length)];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        randomIcon, // Use child-friendly icons
                        width: 50,
                        height: 50,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 40),
                // Answer field
                TextField(
                  controller: answerController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter the number of icons',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8), // Make input field stand out
                  ),
                ),
                SizedBox(height: 20),
                // Submit button
                ElevatedButton(
                  onPressed: _checkAnswer,
                  child: Text('Submit Answer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
