import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/shape_game/screens_ShapeGame/result_shape_screen.dart';

class ShapeScreen extends StatefulWidget {
  @override
  _ShapeScreenState createState() => _ShapeScreenState();
}

class _ShapeScreenState extends State<ShapeScreen> {
  List<String> shapes = ['Circle', 'Square', 'Triangle']; // Sample shapes
  Random random = Random();
  int currentShapeIndex = 0;
  List<String> options = [];
  int correctAnswers = 0;
  int questionCount = 0;
  int totalQuestions = 5;
  String? userId;

  @override
  void initState() {
    super.initState();
    _generateNewShape();
    _getCurrentUserId();
  }

  // Firebase score-saving method
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

  // Fetch current user ID
  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  // Generate a new shape and options for the game
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
        questionCount++;
      });
    } else {
      // Save the score when the game ends
      await _saveScoreToFirebase(correctAnswers);

      // Navigate to the result screen, passing userId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreenShape(
            score: correctAnswers,
            totalQuestions: totalQuestions,
            userId: userId!,
          ),
        ),
      );
    }
  }

  // Handling answer selection
  void _handleAnswer(String selectedShape) {
    if (selectedShape == shapes[currentShapeIndex]) {
      setState(() {
        correctAnswers++;
      });
    }
    _generateNewShape();
  }

  @override
  Widget build(BuildContext context) {
    // Get the size of the device's screen
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;

    return Scaffold(
      appBar: AppBar(title: Text('Shape Game')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Responsive text size based on screen width
          Text(
            'Identify the Shape',
            style: TextStyle(fontSize: width * 0.06), // 6% of screen width
          ),
          SizedBox(height: height * 0.02), // 2% of screen height

          // Responsive shape text size
          Text(
            shapes[currentShapeIndex],
            style: TextStyle(fontSize: width * 0.12), // 12% of screen width
          ),
          SizedBox(height: height * 0.03), // 3% of screen height

          // Responsive button layout
          Column(
            children: options.map((option) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                child: ElevatedButton(
                  onPressed: () => _handleAnswer(option),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.7, height * 0.07), // Button size 70% width and 7% height
                  ),
                  child: Text(
                    option,
                    style: TextStyle(fontSize: width * 0.05), // 5% of screen width
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
