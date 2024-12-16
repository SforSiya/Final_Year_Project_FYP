import 'package:flutter/material.dart';
import 'dart:math';

class MathGrowingImageGame extends StatefulWidget {
  @override
  _MathGrowingImageGameState createState() => _MathGrowingImageGameState();
}

class _MathGrowingImageGameState extends State<MathGrowingImageGame> {
  TextEditingController answerController = TextEditingController();
  int num1 = 0;
  int num2 = 0;
  int answer = 0;
  int correctAnswersCount = 0; // Track number of correct answers
  double imageSize = 30; // Start with an even smaller initial size
  final double maxImageSize = 150; // Cap the maximum size to avoid overflow
  String currentImage = ''; // Variable to store the current image path
  final List<String> imagePaths = [
    'assets/games/grow_icon_1.png',
    'assets/games/grow_icon_2.png',
    'assets/games/grow_icon_3.png',
    'assets/games/grow_icon_4.png',
    'assets/games/grow_icon_5.png',
  ]; // List of 5 different images

  @override
  void initState() {
    super.initState();
    _generateQuestion();
    _selectRandomImage(); // Set a random image only once when the game starts
  }

  // Method to generate a new random math question
  void _generateQuestion() {
    final random = Random();
    setState(() {
      num1 = random.nextInt(10) + 1; // Random number between 1 and 10
      num2 = random.nextInt(10) + 1; // Random number between 1 and 10
      answer = num1 + num2; // Calculate the correct answer
      answerController.clear(); // Clear the text field for the new input
    });
  }

  // Method to select a random image from the list at the start of the game
  void _selectRandomImage() {
    final random = Random();
    setState(() {
      currentImage = imagePaths[random.nextInt(imagePaths.length)];
    });
  }

  // Method to check if the user's answer is correct
  void _checkAnswer() {
    int userAnswer = int.tryParse(answerController.text) ?? -1; // Get user input or set to -1 if invalid

    if (userAnswer == answer) {
      setState(() {
        correctAnswersCount++;
        if (correctAnswersCount <= 5 && imageSize < maxImageSize) {
          imageSize += 20; // Increase image size incrementally
        }
        if (correctAnswersCount == 5) {
          _showCompletionDialog(); // Show completion dialog after 5 correct answers
        } else {
          _showFeedbackDialog(true); // Provide correct feedback
        }
      });
    } else {
      _showFeedbackDialog(false); // Show incorrect answer feedback
    }
  }

  // Show a feedback dialog for correct/incorrect answers
  void _showFeedbackDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(isCorrect ? 'Correct!' : 'Wrong answer!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (isCorrect) {
                  _generateQuestion(); // Generate new question if correct
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Show a dialog when the game is completed (5 correct answers)
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You answered 5 questions correctly!'),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to reset the game
  void _resetGame() {
    setState(() {
      correctAnswersCount = 0;
      imageSize = 30; // Reset the image size to the initial value
      _selectRandomImage(); // Select a new random image for the new game
      _generateQuestion(); // Generate a new question
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math Growing Image Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the math question
            Text(
              'What is $num1 + $num2?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Answer input field
            TextField(
              controller: answerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter your answer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Submit answer button
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text('Submit Answer'),
            ),
            SizedBox(height: 40),
            // Animated image that grows with correct answers
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: imageSize,
              height: imageSize,
              child: currentImage.isNotEmpty
                  ? Image.asset(currentImage) // Display the random image
                  : SizedBox.shrink(), // Show nothing if the image is not loaded
            ),
          ],
        ),
      ),
    );
  }
}
