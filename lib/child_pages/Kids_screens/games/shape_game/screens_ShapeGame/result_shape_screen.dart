import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultScreenShape extends StatelessWidget {
  final int score; // The current score from the game
  final int totalQuestions;
  final String userId; // The user's ID from Firebase Authentication
  final String gameName; // Added gameName to differentiate between games

  ResultScreenShape({
    required this.score,
    required this.totalQuestions,
    required this.userId,
    this.gameName = "shapeGame", // Default to "shapeGame" for this game
  });

  // Function to update the highest score and last 7 scores in Firestore
  Future<int> _updateGameData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Firestore path:
    final DocumentReference gameDataRef = firestore
        .collection('users')
        .doc(userId)
        .collection('kids_data') // Consistent with addition game
        .doc('games')
        .collection('game_scores')
        .doc(gameName); // Store each game under its own document

    int currentHighestScore = 0;
    List<int> lastScores = [];

    try {
      final DocumentSnapshot gameDataSnapshot = await gameDataRef.get();

      // Fetch the current game data
      if (gameDataSnapshot.exists) {
        final data = gameDataSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          currentHighestScore = data['highestScore'] ?? 0;

          // Get the lastScores array if it exists
          if (data.containsKey('lastScores')) {
            lastScores = List<int>.from(data['lastScores']);
          }
        }
      }

      // Update highest score if the current score is greater
      if (score > currentHighestScore) {
        currentHighestScore = score;
        await gameDataRef.set({
          'highestScore': currentHighestScore,
          'lastPlayed': Timestamp.now(),
        }, SetOptions(merge: true));
      } else {
        // Only update the timestamp if no new high score
        await gameDataRef.set({
          'lastPlayed': Timestamp.now(),
        }, SetOptions(merge: true));
      }

      // Append the current score to lastScores
      lastScores.add(score);

      // Keep only the last 7 scores
      if (lastScores.length > 7) {
        lastScores = lastScores.sublist(lastScores.length - 7);
      }

      // Update the scores in Firestore
      await gameDataRef.set({
        'lastScores': lastScores,
      }, SetOptions(merge: true));

      print("Game data updated successfully!");

    } catch (e) {
      print("Error updating game data: $e");
    }

    return currentHighestScore; // Return updated highest score
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Over')),
      body: FutureBuilder<int>(
        future: _updateGameData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            int highestScore = snapshot.data!;
            bool isNewHighScore = score == highestScore;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Game Over!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You scored $score out of $totalQuestions',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Highest Score: $highestScore',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isNewHighScore ? Colors.green : Colors.black,
                    ),
                  ),
                  if (isNewHighScore) ...[
                    SizedBox(height: 10),
                    Text(
                      'New High Score!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to play again
                      Navigator.pop(context);
                    },
                    child: Text('Play Again'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}




/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultScreenShape extends StatelessWidget {
  final int score;  // The current score from the game
  final int totalQuestions;
  final String userId;  // The user's ID from Firebase Authentication

  ResultScreenShape({
    required this.score,
    required this.totalQuestions,
    required this.userId,
  });

  // Function to update the highest score and last 7 scores in Firestore
  Future<int> _updateGameData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the specific user's game data
    final DocumentReference gameDataRef = firestore
        .collection('users')
        .doc(userId)
        .collection('gameData')
        .doc('shapeGame'); // Assuming 'shapeGame' is the document for this game

    int currentHighestScore = 0;
    List<int> lastScores = [];

    try {
      final DocumentSnapshot gameDataSnapshot = await gameDataRef.get();

      // Check if the document already exists and cast the data to a map
      if (gameDataSnapshot.exists) {
        final data = gameDataSnapshot.data() as Map<String, dynamic>?;

        // Fetch the current highest score if it exists
        if (data != null) {
          currentHighestScore = data['highestScore'] ?? 0;

          // Check if the 'lastScores' field exists, if not initialize it as an empty list
          if (data.containsKey('lastScores')) {
            lastScores = List<int>.from(data['lastScores']);
          }
        }
      }

      // If the current score is higher than the highest saved score, update it
      if (score > currentHighestScore) {
        await gameDataRef.set({
          'highestScore': score,
          'lastPlayed': Timestamp.now(),
        }, SetOptions(merge: true));
        currentHighestScore = score;  // Set current highest score to the new score
      } else {
        await gameDataRef.set({
          'lastPlayed': Timestamp.now(),
        }, SetOptions(merge: true));
      }

      // Add the current score to the lastScores array
      lastScores.add(score);

      // Ensure that the array contains only the last 7 scores
      if (lastScores.length > 7) {
        lastScores = lastScores.sublist(lastScores.length - 7);
      }

      // Update the lastScores array in Firestore
      await gameDataRef.set({
        'lastScores': lastScores,
      }, SetOptions(merge: true));

      print("Game data updated successfully!");

    } catch (e) {
      print("Error updating game data: $e");
    }

    // Return the current highest score for display purposes
    return currentHighestScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Over')),
      body: FutureBuilder<int>(
        future: _updateGameData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            int highestScore = snapshot.data!;
            bool isNewHighScore = score == highestScore;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Game Over!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You scored $score out of $totalQuestions',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Highest Score: $highestScore',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isNewHighScore ? Colors.green : Colors.black),
                  ),
                  if (isNewHighScore) ...[
                    SizedBox(height: 10),
                    Text(
                      'New High Score!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to the shape screen to play again
                      Navigator.pop(context);
                    },
                    child: Text('Play Again'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}*/

