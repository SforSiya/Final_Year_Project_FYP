import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/Addition_Game/result_screen.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _timeLeft = 30; // Game time in seconds
  int _firstNumber = 0;
  int _secondNumber = 0;
  int _score = 0;
  int _totalQuestions = 0;
  int _correctAnswers = 0;
  String _userAnswer = '';
  Timer? _timer;
  final _random = Random();
  final TextEditingController _controller = TextEditingController(); // Controller for the TextField

  @override
  void initState() {
    super.initState();
    _startTimer();
    _generateQuestion();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _generateQuestion() {
    setState(() {
      _firstNumber = _random.nextInt(10); // Generates a number between 0 and 9
      _secondNumber = _random.nextInt(10);
    });
  }

  void _checkAnswer() {
    int correctAnswer = _firstNumber + _secondNumber;
    if (int.tryParse(_userAnswer) == correctAnswer) {
      _correctAnswers++;
    }
    _totalQuestions++;
    _userAnswer = '';
    _controller.clear(); // Clear the TextField after submitting the answer
    _generateQuestion();
  }

  void _endGame() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Result_Screen(
          score: _correctAnswers,
          totalQuestions: _totalQuestions,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose(); // Dispose of the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9CA986), // Set the background color
      appBar: AppBar(title: Text('Answer the Questions')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0), // Add padding around the container
          margin: const EdgeInsets.all(16.0), // Add margin to keep container away from screen edges
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the container
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for the container
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color
                blurRadius: 8.0, // Blur effect
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Time Left: $_timeLeft seconds',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '$_firstNumber + $_secondNumber = ?',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller, // Assign the controller to the TextField
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _userAnswer = value;
                  },
                  onSubmitted: (value) {
                    _checkAnswer();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your Answer',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9CA986), // Button background color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
