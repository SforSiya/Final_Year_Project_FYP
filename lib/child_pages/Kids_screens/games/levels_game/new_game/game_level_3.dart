import 'package:flutter/material.dart';
import 'dart:math';

class MathGame extends StatefulWidget {
  @override
  _MathGameState createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  Random random = Random();
  int number1 = 0;
  int number2 = 0;
  int correctAnswer = 0;
  List<int> options = [];
  String feedbackMessage = '';

  int totalQuestions = 0; // Track total questions asked
  int correctAnswers = 0; // Track correct answers

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  // Generate a new question and answer options
  void _generateNewQuestion() {
    setState(() {
      number1 = random.nextInt(10) + 1;
      number2 = random.nextInt(10) + 1;
      correctAnswer = number1 + number2;

      // Generate random options including the correct answer
      options = [
        correctAnswer,
        random.nextInt(20) + 1, // Random wrong option
        random.nextInt(20) + 1, // Another random wrong option
      ]..shuffle(); // Shuffle the options to randomize their order

      feedbackMessage = ''; // Reset feedback
    });
  }

  // Check if the chosen answer is correct
  void _checkAnswer(int selectedAnswer) {
    setState(() {
      totalQuestions++; // Increment total questions counter
      if (selectedAnswer == correctAnswer) {
        correctAnswers++; // Increment correct answers counter
        feedbackMessage = 'Correct!';
      } else {
        feedbackMessage = 'Wrong, try again!';
      }
    });
  }

  // Show the summary dialog box when the game is finished
  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('You answered $correctAnswers out of $totalQuestions questions correctly.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  // Reset the game
                  totalQuestions = 0;
                  correctAnswers = 0;
                  _generateNewQuestion();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Math Game'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Score: $correctAnswers/$totalQuestions',
                style: TextStyle(
                  fontSize: screenWidth * 0.05, // Adjust based on screen width
                  color: Colors.brown[900], // Dark brown color
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Green button background color
              ),
              onPressed: _showFinishDialog, // Show dialog when pressed
              child: Text('Finish', style: TextStyle(fontSize: screenWidth * 0.045)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // GIF background using Image.asset for local assets
          Positioned.fill(
            child: Image.asset(
              'assets/level_3_background.gif', // Replace with your own GIF asset path
              fit: BoxFit.cover, // Make the GIF cover the entire background
            ),
          ),
          // Use SingleChildScrollView to avoid overflow
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Display the equation
                    Text(
                      '$number1 + $number2 = ?',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08, // Adjust the font size based on screen width
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05), // Adjust spacing dynamically

                    // Display answer options as buttons
                    Column(
                      children: options.map((option) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _checkAnswer(option); // Check if the answer is correct
                            },
                            child: Text(
                              '$option',
                              style: TextStyle(
                                fontSize: screenWidth * 0.07, // Adjust font size for options
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: screenHeight * 0.05), // Adjust spacing dynamically

                    // Display feedback message (Correct / Wrong)
                    Text(
                      feedbackMessage,
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Adjust font size for feedback
                        color: feedbackMessage == 'Correct!' ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Adjust spacing dynamically

                    // Button to generate a new question
                    ElevatedButton(
                      onPressed: _generateNewQuestion,
                      child: Text(
                        'Next Question',
                        style: TextStyle(fontSize: screenWidth * 0.05), // Adjust button text size
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
