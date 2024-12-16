import 'package:flutter/material.dart';
import 'dart:math';
import 'game_level_2.dart';

class MonsterMathGame extends StatefulWidget {
  @override
  _MonsterMathGameState createState() => _MonsterMathGameState();
}

class _MonsterMathGameState extends State<MonsterMathGame> {
  TextEditingController answerController = TextEditingController();
  int num1 = 0;
  int num2 = 0;
  int answer = 0;
  int totalQuestions = 0; // Track the total number of questions asked
  int correctAnswersCount = 0; // Track the number of correct answers
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  // Method to generate a new random question
  void _generateQuestion() {
    final random = Random();
    setState(() {
      num1 = random.nextInt(10) + 1; // Random number between 1 and 10
      num2 = random.nextInt(10) + 1; // Random number between 1 and 10
      answer = num1 + num2; // Calculate the correct answer
      answerController.clear(); // Clear the text field for new input
      totalQuestions++; // Increment the total questions counter
    });
  }

  // Method to check if the user's answer is correct
  void _checkAnswer() {
    int userAnswer = int.tryParse(answerController.text) ?? -1; // Get user input or set to -1 if invalid

    setState(() {
      if (userAnswer == answer) {
        isCorrect = true;
        correctAnswersCount++;
        if (correctAnswersCount == 5) {
          _showLevelUpDialog(); // Show the level-up dialog after 5 correct answers
        } else {
          _showResultDialog(isCorrect);
        }
      } else {
        isCorrect = false;
        _showResultDialog(isCorrect);
      }
    });
  }

  // Show the result dialog for correct/incorrect answers
  void _showResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isCorrect ? 'assets/Alena_Sofina_happy.gif' : 'assets/Alena_Sofina_sad.gif',
                height: MediaQuery.of(context).size.height * 0.2, // Responsive image height
                width: MediaQuery.of(context).size.width * 0.4, // Responsive image width
              ),
              SizedBox(height: 20),
              Text(
                isCorrect ? 'Well done!' : 'Wrong answer!',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03, // Responsive font size
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _generateQuestion(); // Generate a new question after dialog is closed
              },
            ),
          ],
        );
      },
    );
  }

  // Show a result dialog with statistics when user finishes the game
  void _showFinalResultDialog() {
    double percentage = (correctAnswersCount / totalQuestions) * 100; // Calculate the percentage
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Questions asked: $totalQuestions'),
              Text('Correct answers: $correctAnswersCount'),
              Text('Percentage: ${percentage.toStringAsFixed(2)}%'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  correctAnswersCount = 0; // Reset correct answers count
                  totalQuestions = 0; // Reset total questions count
                });
                _generateQuestion(); // Start a new game
              },
            ),
          ],
        );
      },
    );
  }

  // Show a dialog after 5 correct answers for level-up, along with results
  void _showLevelUpDialog() {
    double percentage = (correctAnswersCount / totalQuestions) * 100; // Calculate percentage
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Congratulations! You\'ve answered 5 questions correctly!',
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
              ),
              SizedBox(height: 10),
              Text('Questions asked: $totalQuestions'),
              Text('Correct answers: $correctAnswersCount'),
              Text('Percentage: ${percentage.toStringAsFixed(2)}%'),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              child: Text(
                'Level 2',
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DotCountingGame()), // Go to level 2 game
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Show a dialog for confirming if the user wants to finish the game
  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to finish the game?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog and continue the game
              },
            ),
            TextButton(
              child: Text('Sure'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _showFinalResultDialog(); // Show the final result dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate screen dimensions for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.05; // 5% of screen width for padding

    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Math Game'),
        automaticallyImplyLeading: false,
        actions: [
          // Add Finish button to confirm if the user wants to finish the game
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Green button background color
            ),
            onPressed: () {
              _showFinishDialog(); // Show confirmation dialog to finish the game
            },
            child: Text(
              'Finish',
              style: TextStyle(color: Colors.black), // Set text color to black
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white70,
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Center GIF: Display a neutral monster GIF in the center
            Image.asset(
              'assets/Alena_Sofina_sad.gif', // This could be a neutral GIF
              height: screenHeight * 0.25, // Responsive height
              width: screenWidth * 0.5, // Responsive width
            ),
            SizedBox(height: screenHeight * 0.04),
            Text(
              "Help me!",
              style: TextStyle(fontSize: screenHeight * 0.03, color: Colors.purple.shade700),
            ),
            SizedBox(height: screenHeight * 0.04),
            // Math question
            Text(
              'What is $num1 + $num2?',
              style: TextStyle(fontSize: screenHeight * 0.03),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Answer field
            TextField(
              controller: answerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter your answer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Submit button
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text(
                'Submit Answer',
                style: TextStyle(fontSize: screenHeight * 0.025),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
