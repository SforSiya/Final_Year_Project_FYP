import 'package:flutter/material.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/shape_game/screens_ShapeGame/shape_splash_screen.dart';
import 'Addition_Game/first_page.dart';
import 'car_game/car_game.dart';
import 'car_game/firat_page_car.dart';

class NumbersPage extends StatelessWidget {
  const NumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the gradient behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Games for Kids",
          style: TextStyle(
            color: Color(0xFF5c724a), // Green text
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Comic Sans MS',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFAF7), Color(0xFFFDFAF7),], // Off-white to green
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Let's Play!",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5c724a), // Playful green
                    fontFamily: 'Comic Sans MS',
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                buildGameButton(
                  context,
                  'Addition Game',
                  Icons.add_circle,
                  const Color(0xFFa3b68a), // Amber
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                buildGameButton(
                  context,
                  'Shapes Game',
                  Icons.category,
                  const Color(0xFFa3b68a), // Light Green
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShapeSplashScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                buildGameButton(
                  context,
                  'Matching Game',
                  Icons.linear_scale,
                  const Color(0xFFa3b68a), // Light Blue
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => carSplashScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGameButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: const Offset(2, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Comic Sans MS',
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black38,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
