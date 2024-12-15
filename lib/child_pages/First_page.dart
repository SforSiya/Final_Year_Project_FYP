import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Kids_screens/Kids_Home.dart';

class ChildHomePage extends StatefulWidget {
  final String userName;
  final String userId; // Pass the user ID to fetch child details from Firestore.

  const ChildHomePage({required this.userName, required this.userId, Key? key})
      : super(key: key);

  @override
  _ChildHomePageState createState() => _ChildHomePageState();
}

class _ChildHomePageState extends State<ChildHomePage> {
  @override
  void initState() {
    super.initState();
    _delayedCheck();
  }

  /// Delays for 5 seconds before checking the child's age.
  Future<void> _delayedCheck() async {
    await Future.delayed(const Duration(seconds: 3));
    _checkChildAge();
  }

  /// Function to fetch the child's age from Firestore and navigate accordingly.
  Future<void> _checkChildAge() async {
    try {
      // Reference to the Firestore document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Replace 'users' with your Firestore collection
          .doc(widget.userId) // The document ID is the user's ID.
          .get();

      // Extract age from the Firestore document
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        int age = data['age']; // Ensure 'age' field exists in Firestore.

        // Navigate based on the age
        if (age >= 12) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TeenagerPage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const KidsHome(),
            ),
          );
        }
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error fetching age: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.asset(
              'assets/images/First_page.gif', // Ensure the path matches your asset directory
              fit: BoxFit.cover,
            ),
          ),
          // Welcome Message
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeenagerPage extends StatelessWidget {
  const TeenagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Teenager Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Teenager Page!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

