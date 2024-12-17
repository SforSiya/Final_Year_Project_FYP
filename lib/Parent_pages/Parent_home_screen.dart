import 'package:final_year_project/Authentication/Login_Screen.dart';
import 'package:final_year_project/Chatbot/chat_screen.dart';
import 'package:final_year_project/Education/education_screen.dart';
import 'package:flutter/material.dart';
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
  int _currentIndex = 0;

  // Function to handle logout
  void _logout() {
    // You can perform any logout logic here, e.g., clearing user data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),  // Navigate to the login screen
    );
  }

  // Function to navigate to the Chat screen (replace with your chat screen)
  void _openChat() {
   
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),  // Navigate to the chat screen
    );
    print("Chat button pressed");
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      ParentHome(userName: widget.userName, parentEmail: widget.parentEmail),
      BookAppointment(parentEmail: widget.parentEmail),
      AppointmentStatus(parentEmail: widget.parentEmail),
      EducationScreen(),  // The new Education screen
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0
            ? 'Parent Home'
            : _currentIndex == 1
                ? 'Book Appointment'
                : _currentIndex == 2
                    ? 'Appointment Status'
                    : 'Education'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,  // Logout functionality
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          primaryColor: Colors.green,
          canvasColor: Colors.green,  // Set the background color of the bottom navigation bar
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.white,  // White for selected items
          unselectedItemColor: Colors.white70,  // Light white for unselected items
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Book Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),  // Icon for Education
              label: 'Education',  // Label for Education
            ),
          ],
          // Customizing text style directly in the BottomNavigationBar
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(color: Colors.white),  // White color for selected label
          unselectedLabelStyle: TextStyle(color: Colors.white70),  // Light white for unselected label
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openChat,  // Action for chat button
        backgroundColor: Colors.green,
        child: Icon(Icons.chat, color: Colors.white),  // Chat icon
      ),
    );
  }
}
