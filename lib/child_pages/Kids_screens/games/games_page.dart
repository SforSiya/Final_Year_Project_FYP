import 'package:flutter/material.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/shape_game/screens_ShapeGame/shape_splash_screen.dart';

import 'Addition_Game/first_page.dart';
import 'levels_game/level_game.dart';

class NumbersPage extends StatelessWidget {
  const NumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
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
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Comic Sans MS', // Optional: Add playful font
                  ),
                ),
                const SizedBox(height: 40),
                buildGameButton(
                  context,
                  'Addition',
                  Icons.add,
                  [Colors.redAccent, Colors.orangeAccent],
                  Colors.red[100],
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                buildGameButton(
                  context,
                  'Shapes',
                  Icons.category,
                  [Colors.pinkAccent, Colors.purpleAccent],
                  Colors.pink[100],
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShapeSplashScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                buildGameButton(
                  context,
                  'Match',
                  Icons.linear_scale,
                  [Colors.greenAccent, Colors.teal],
                  Colors.purple[100],
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SplashScreen_lvl(),
                      ),
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

  Widget buildGameButton(
      BuildContext context, String title, IconData icon, List<Color> gradientColors, Color? shadowColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.black12,
              blurRadius: 8.0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Comic Sans MS', // Optional: Playful font for kids
              ),
            ),
          ],
        ),
      ),
    );
  }
}
