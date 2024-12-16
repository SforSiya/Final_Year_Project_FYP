import 'package:flutter/material.dart';

class LevelProgressPage extends StatefulWidget {
  @override
  _LevelProgressPageState createState() => _LevelProgressPageState();
}

class _LevelProgressPageState extends State<LevelProgressPage> {
  int currentLevel = 1; // Track the current unlocked level

  // Method to unlock the next level and draw a green line
  void _unlockNextLevel() {
    if (currentLevel < 4) {
      setState(() {
        currentLevel++;
      });
    } else {
      _showCompletionDialog();
    }
  }

  // Show a dialog when all levels are completed
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have completed all levels!'),
          actions: [
            TextButton(
              child: Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetLevels();
              },
            ),
          ],
        );
      },
    );
  }

  // Reset the game progress to level 1
  void _resetLevels() {
    setState(() {
      currentLevel = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level Progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level 1 Circle
            _buildLevelCircle(1),
            _buildConnectorLine(1),
            // Level 2 Circle
            _buildLevelCircle(2),
            _buildConnectorLine(2),
            // Level 3 Circle
            _buildLevelCircle(3),
            _buildConnectorLine(3),
            // Level 4 Circle
            _buildLevelCircle(4),
            SizedBox(height: 30),
            // Button to mark the level as passed and unlock the next level
            ElevatedButton(
              onPressed: currentLevel <= 4 ? _unlockNextLevel : null,
              child: Text('Pass Level $currentLevel'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build each level circle
  Widget _buildLevelCircle(int level) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: level <= currentLevel ? Colors.green : Colors.grey,
      child: Text(
        'Level $level',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  // Widget to build the connector line between levels
  Widget _buildConnectorLine(int level) {
    return Container(
      width: 3,
      height: 50,
      color: level < currentLevel ? Colors.green : Colors.grey,
    );
  }
}

void main() => runApp(MaterialApp(home: LevelProgressPage()));
