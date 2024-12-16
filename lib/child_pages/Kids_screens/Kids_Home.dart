import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/child_pages/Kids_screens/profile/profile_kid.dart';
import 'package:final_year_project/child_pages/Kids_screens/shapes_reading/shape_page.dart';
import 'Progress_page/progress_screen.dart';
import 'Reading_pages/Reading.dart';
import 'games/games_page.dart';


class KidsHome extends StatefulWidget {
  const KidsHome({Key? key}) : super(key: key);

  @override
  State<KidsHome> createState() => _KidsHomeState();
}

class _KidsHomeState extends State<KidsHome> {
  int _selectedIndex = 0; // For keeping track of the selected tab

  // List of screens to display in Bottom Navigation Bar
  List<Widget> _screens() {
    return [
      buildHomeScreen(),
      KidsProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildHomeScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('kids_data')
                    .doc('child_profile')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: const [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                              'assets/kids/auto_profile.png'),
                        ),
                        SizedBox(height: 16),
                        Text('Good Morning,'),
                        Text('Loading...', style: TextStyle(
                            fontWeight: FontWeight.bold)),
                      ],
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData ||
                      !snapshot.data!.exists) {
                    return Column(
                      children: const [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                              'assets/kids/auto_profile.png'),
                        ),
                        SizedBox(height: 16),
                        Text('Good Morning,'),
                        Text('Guest', style: TextStyle(fontWeight: FontWeight
                            .bold)),
                      ],
                    );
                  }

                  Map<String, dynamic> profileData = snapshot.data!
                      .data() as Map<String, dynamic>;

                  String name = profileData['name'] ?? 'Guest';
                  String avatar = profileData['avatar'] ??
                      'assets/kids/auto_profile.png';

                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: avatar.startsWith('assets')
                            ? AssetImage(avatar) as ImageProvider
                            : NetworkImage(avatar),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Good Morning,',
                        style: TextStyle(fontSize: 18, color: Color(
                            0xFFFF9F29)),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9F29),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Grid section
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildGridItem(
                  context,
                  'assets/kids/games_icon.png',
                  'Numbers',
                  'All about number',
                  const NumbersPage(),
                  const Color(0xFFFFF5E5),
                ),
                buildGridItem(
                  context,
                  'assets/kids/reading_icon.png',
                  'Reading',
                  'Reading some words',
                   ReadingPage(),
                  const Color(0xFFFFF5E5),
                ),
                buildGridItem(
                  context,
                  'assets/kids/Progress_icon.png',
                  'Progress',
                  'See your progress',
                  ProgressGraphScreen(userId: 'userId'),
                  const Color(0xFFFFF5E5),
                ),
                buildGridItem(
                  context,
                  'assets/kids/shapes_icon.png',
                  'Shapes',
                  'Learn shapes',
                  ShapesPage(),
                  const Color(0xFFFFF5E5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, String imagePath, String title,
      String subtitle, Widget page, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 60, height: 60),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF354A2F),
      // Set the background color
      body: _screens()[_selectedIndex],
      // Displays either Home or Profile screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF9F29),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

