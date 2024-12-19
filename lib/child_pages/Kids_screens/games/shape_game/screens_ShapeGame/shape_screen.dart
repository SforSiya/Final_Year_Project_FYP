import 'package:final_year_project/child_pages/Kids_screens/games/shape_game/screens_ShapeGame/result_shape_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShapeScreen extends StatefulWidget {
  @override
  _ShapeScreenState createState() => _ShapeScreenState();
}

class _ShapeScreenState extends State<ShapeScreen> {
  final List<String> shapes = [
    'Rectangle',
    'Circle',
    'Square',
    'Triangle',
    'Pentagon',
    'Quadrilateral',
    'Star',
    'Diamond',
    'Heart',
  ];

  final Map<String, String> shapeImages = {
    'Rectangle': 'assets/shapes/rectangle.png',
    'Circle': 'assets/shapes/circle.png',
    'Square': 'assets/shapes/square.png',
    'Triangle': 'assets/shapes/triangle.png',
    'Pentagon': 'assets/shapes/pentagon.png',
    'Quadrilateral': 'assets/shapes/quadrilateral.png',
    'Star': 'assets/shapes/star.png',
    'Diamond': 'assets/shapes/diamond.png',
    'Heart': 'assets/shapes/heart.png',
  };

  Random random = Random();
  int currentShapeIndex = 0;
  int questionCount = 0;
  int correctAnswers = 0;
  List<String> options = [];
  String? userId;
  bool isAnswerSelected = false;
  bool isAnswerCorrect = false;
  String feedbackMessage = '';
  final int totalQuestions = 8;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    _generateNewShape();
  }

  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Future<void> _saveScoreToFirebase(int score) async {
    if (userId != null) {
      CollectionReference progressRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('progress');
      DocumentReference scoreDocRef = progressRef.doc('shape_game');

      DocumentSnapshot snapshot = await scoreDocRef.get();

      if (snapshot.exists) {
        int highestScore = snapshot['highestScore'] ?? 0;
        if (score > highestScore) {
          await scoreDocRef.set({
            'highestScore': score,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      } else {
        await scoreDocRef.set({
          'highestScore': score,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  void _generateNewShape() async {
    if (questionCount < totalQuestions) {
      setState(() {
        currentShapeIndex = random.nextInt(shapes.length);
        options = [shapes[currentShapeIndex]];

        while (options.length < 3) {
          String incorrectShape = shapes[random.nextInt(shapes.length)];
          if (!options.contains(incorrectShape)) {
            options.add(incorrectShape);
          }
        }
        options.shuffle();
        isAnswerSelected = false; // Reset selection status
        isAnswerCorrect = false;  // Reset answer correctness
        feedbackMessage = '';     // Clear feedback message
        questionCount++;
      });
    } else {
      // Save score and navigate to the result screen
      await _saveScoreToFirebase(correctAnswers);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreenShape(
            score: correctAnswers,
            totalQuestions: totalQuestions,
          ),
        ),
      );
    }
  }


  void _checkAnswer(String selectedShape) {
    setState(() {
      isAnswerSelected = true; // Answer is selected

      if (selectedShape == shapes[currentShapeIndex]) {
        correctAnswers++;
        isAnswerCorrect = true;
        feedbackMessage = 'Correct!';
      } else {
        isAnswerCorrect = false;
        feedbackMessage = 'Try Again!';
      }
    });

    // Generate a new shape after a short delay
    Future.delayed(Duration(seconds: 1), () {
      _generateNewShape();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shape Recognition Game'),
        backgroundColor: Color(0xFF1572A1),
      ),
      body: Container(
        width: double.infinity,  // Ensures full screen width
        height: double.infinity, // Ensures full screen height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDEEDF0), Color(0xFF9AD0EC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Guess the Shape!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Image.asset(
              shapeImages[shapes[currentShapeIndex]]!,
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            // Display feedback (Correct or Try Again) after the user answers
            Text(
              feedbackMessage,
              style: TextStyle(
                fontSize: 24,
                color: isAnswerCorrect ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Display options as rectangular buttons in a row with consistent size
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: options.map((option) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // No rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0), // Padding
                    elevation: 5, // Shadow for a raised look
                    minimumSize: Size(120, 50), // Smaller button size with same width
                  ),
                  onPressed: isAnswerSelected
                      ? null // Disable buttons after selection
                      : () => _checkAnswer(option),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // A playful font
                    ),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
