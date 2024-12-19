import 'package:flutter/material.dart';
import 'package:final_year_project/Authentication/Login_Screen.dart';
import 'package:final_year_project/Chatbot/chat_screen.dart';
import 'package:final_year_project/Education/education_screen.dart';
import 'package:final_year_project/Group_Chat/groupchat.dart';
import 'parent_home.dart';
import 'book_appointment.dart';
import 'appointment_status.dart';

class ParentHomeScreen extends StatefulWidget {
  final String userName;
  final String parentEmail;

  const ParentHomeScreen({
    required this.userName,
    required this.parentEmail,
    Key? key,
  }) : super(key: key);

  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  // Function to handle navigation
  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Function to handle logout
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Home'),
        backgroundColor: const Color(0xFFFFDE59),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Home Container (takes full width)
            _buildClickableContainer(
              label: 'Register \nChildren',
              imagePath: 'assets/children.png',
              onTap: () => _navigateToScreen(
                ParentHome(userName: widget.userName, parentEmail: widget.parentEmail),
              ),
              width: MediaQuery.of(context).size.width, // Full width
              isHome: true, // Flag to indicate if it's the home container
            ),
            const SizedBox(height: 16),
            // Row 1: Book Appointment and Status (each takes half the width)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildClickableContainer(
                  label: 'Book Appointment',
                  imagePath: 'assets/appointment.png',
                  onTap: () => _navigateToScreen(
                    BookAppointment(parentEmail: widget.parentEmail),
                  ),
                  width: MediaQuery.of(context).size.width * 0.45, // Half width
                ),
                _buildClickableContainer(
                  label: 'Status',
                  imagePath: 'assets/status.png',
                  onTap: () => _navigateToScreen(
                    AppointmentStatus(parentEmail: widget.parentEmail),
                  ),
                  width: MediaQuery.of(context).size.width * 0.45, // Half width
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Row 2: Education and Group Chat (each takes half the width)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildClickableContainer(
                  label: 'Education',
                  imagePath: 'assets/education.png',
                  onTap: () => _navigateToScreen(EducationScreen()),
                  width: MediaQuery.of(context).size.width * 0.45, // Half width
                ),
                _buildClickableContainer(
                  label: 'Group Chat',
                  imagePath: 'assets/groupchat.png',
                  onTap: () => _navigateToScreen(GroupChat()),
                  width: MediaQuery.of(context).size.width * 0.45, // Half width
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Chatbot screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        backgroundColor: const Color(0xFFFFDE59),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  // Reusable clickable container widget with dynamic width and image size
  Widget _buildClickableContainer({
    required String label,
    required String imagePath,
    required VoidCallback onTap,
    required double width, // Dynamic width for the container
    bool isHome = false, // Flag to check if it's the Home screen
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width, // Set width dynamically
        height: isHome ? 150 : 120, // Increased height
        decoration: BoxDecoration(
          color: const Color(0xFFFFDE59),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: isHome
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath, height: 120, width: 120), // Increased image size
                  const SizedBox(width: 16),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 24, // Increased font size
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 1.5, 
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath, height: 64, width: 64), // Increased image size
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 20, // Increased font size
                      fontWeight: FontWeight.w600, 
                      fontFamily: 'Montserrat', 
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
