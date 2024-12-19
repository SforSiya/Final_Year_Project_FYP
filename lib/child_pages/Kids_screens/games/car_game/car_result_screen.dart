import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'car_game.dart';

class CarResultScreen extends StatefulWidget {
  final int score;

  CarResultScreen({required this.score});

  @override
  _CarResultScreenState createState() => _CarResultScreenState();
}

class _CarResultScreenState extends State<CarResultScreen> {
  int highestScore = 0;
  bool isNewHighestScore = false;

  @override
  void initState() {
    super.initState();
    fetchHighestScore(); // Fetch the current highest score when the screen is initialized
  }

  Future<void> fetchHighestScore() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User not authenticated.");

      final firestore = FirebaseFirestore.instance;
      const String gameName = "car_game"; // Game name for car game

      final gameDoc = firestore
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('games')
          .collection('game_scores')
          .doc(gameName);

      final gameData = await gameDoc.get();

      if (gameData.exists) {
        setState(() {
          highestScore = gameData['highestScore'] ?? 0;
        });
      }
    } catch (e) {
      print("Error fetching highest score: $e");
    }
  }

  Future<void> saveGameData(int score) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User not authenticated.");

      final firestore = FirebaseFirestore.instance;
      const String gameName = "car_game"; // Game name for car game

      final gameDoc = firestore
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('games')
          .collection('game_scores')
          .doc(gameName);

      final gameData = await gameDoc.get();

      if (gameData.exists) {
        List<int> lastScores = List<int>.from(gameData['lastScores'] ?? []);
        int currentHighestScore = gameData['highestScore'] ?? 0;

        // Check if the new score is higher than the current highest score
        if (score > currentHighestScore) {
          currentHighestScore = score;
          isNewHighestScore = true; // Set flag for new highest score
        }

        lastScores.add(score);
        if (lastScores.length > 5) {
          lastScores = lastScores.sublist(lastScores.length - 5);
        }

        await gameDoc.update({
          'highestScore': currentHighestScore,
          'lastScores': lastScores,
          'lastPlayed': FieldValue.serverTimestamp(),
        });

        // Update the highest score in the UI
        setState(() {
          highestScore = currentHighestScore;
        });

        // Show congratulatory message when a new highest score is achieved
        if (isNewHighestScore) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Congratulations! New Highest Score!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await gameDoc.set({
          'highestScore': score,
          'lastScores': [score],
          'lastPlayed': FieldValue.serverTimestamp(),
        });

        setState(() {
          highestScore = score;
        });
      }
    } catch (e) {
      print("Error saving game data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFAF7),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 100, color: Colors.yellow),
                SizedBox(height: 16),
                Text(
                  "Game Over!",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                ),

                SizedBox(height: 16),
                Text(
                  "Your Score: ${widget.score}",
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
                SizedBox(height: 16),
                Text(
                  "Highest Score: $highestScore",
                  style: TextStyle(fontSize: 24, color: Colors.green),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    saveGameData(widget.score); // Save the score and check if it’s a new high score
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CarGameScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Restart",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    saveGameData(widget.score); // Save the score and check if it’s a new high score
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Exit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
