import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/shape_game/screens_ShapeGame/result_shape_screen.dart';

class ShapeScreen extends StatefulWidget {
  @override
  _ShapeScreenState createState() => _ShapeScreenState();
}

class _ShapeScreenState extends State<ShapeScreen> {
  final List<String> shapes = [
    "Rectangle",
    "Circle",
    "Square",
    "Triangle",
    "Pentagon",
    "Quadrilateral"
  ];

  final List<Widget> shapeWidgets = [
    _drawRectangle(),
    _drawCircle(),
    _drawSquare(),
    _drawTriangle(),
    _drawPentagon(),
    _drawQuadrilateral(),
  ];

  Random random = Random();
  int currentShapeIndex = 0;
  int questionCount = 0;
  int correctAnswers = 0;
  List<String> options = [];
  String? userId; // Store user ID here

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(); // Fetch user ID on initialization
    _generateNewShape();
  }

  // Fetch the current user's ID
  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  // Generate a new shape
  void _generateNewShape() {
    setState(() {
      if (questionCount < shapes.length) {
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
      } else {
        // Navigate to ResultScreenShape with userId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreenShape(
              score: correctAnswers,
              totalQuestions: shapes.length,
              userId: userId!, // Pass userId here
            ),
          ),
        );
      }
    });
  }

  // Check the answer and show a dialog
  void _checkAnswer(String selectedShape) {
    bool isCorrect = selectedShape == shapes[currentShapeIndex];
    if (isCorrect) {
      correctAnswers++;
    }
    String title = isCorrect ? "Well Done!" : "Incorrect!";
    String buttonText = "Next";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isCorrect ? Colors.green[50] : Colors.red[50],
        title: Text(
          title,
          style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
        ),
        actions: [
          TextButton(
            child: Text(buttonText, style: TextStyle(fontSize: 18)),
            onPressed: () {
              Navigator.of(context).pop();
              _generateNewShape();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shape Recognition Game'),
        backgroundColor: Color(0xFF1572A1),
        foregroundColor: Colors.white,
      ),
      body: Container(
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
              "Guess the Shape!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
            Center(child: shapeWidgets[currentShapeIndex]),
            SizedBox(height: 30),
            ...options.map((option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF594545),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  elevation: 5,
                ),
                onPressed: () => _checkAnswer(option),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// Functions to draw shapes
Widget _drawRectangle() {
  return Container(
    width: 100,
    height: 60,
    decoration: BoxDecoration(
      color: Color(0xFFAD88C6),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

Widget _drawCircle() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Color(0xFFA87676),
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)],
    ),
  );
}

Widget _drawSquare() {
  return Container(
    width: 100,
    height: 100,
    color: Color(0xFF3A4D39),
  );
}

Widget _drawTriangle() {
  return CustomPaint(
    size: Size(100, 100),
    painter: TrianglePainter(),
  );
}

Widget _drawPentagon() {
  return CustomPaint(
    size: Size(100, 100),
    painter: PentagonPainter(),
  );
}

Widget _drawQuadrilateral() {
  return CustomPaint(
    size: Size(100, 100),
    painter: QuadrilateralPainter(),
  );
}

// Custom painter for triangle
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.greenAccent;
    Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for pentagon
class PentagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.pinkAccent;
    Path path = Path();
    double angle = (pi * 2) / 5;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;
    for (int i = 0; i < 5; i++) {
      double x = center.dx + radius * cos(i * angle - pi / 2);
      double y = center.dy + radius * sin(i * angle - pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for quadrilateral
class QuadrilateralPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.purpleAccent;
    Path path = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
