import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'kid_register.dart';

class ParentHomeScreen extends StatelessWidget {
  final String userName;
  final String parentEmail;

  ParentHomeScreen({required this.userName, required this.parentEmail});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      body: Column(
        children: [
          // Header with avatar and name
          Container(
            color: Colors.green,
            height: screenHeight * 0.25, // Set height to one-fourth of the screen
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.04,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.07,
                  backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Text(
                    'Hello $userName', // Correct string interpolation
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Add Child Registration Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddChildScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                  child: const Text('+ Add Child'),
                ),
              ],
            ),
          ),

          // Body Content: Fetch and display child data
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('parentEmail', isEqualTo: parentEmail)
                  .where('role', isEqualTo: 'child') // Ensure only children are fetched
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No children registered yet. Add a child to view their details.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // Display list of children
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var childData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return Container(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              childData['name'] ?? 'Unknown', // Child's name
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${childData['age'] ?? 'N/A'} years', // Child's age
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
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





/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'kid_register.dart';

class ParentHomeScreen extends StatelessWidget {
  final String userName;
  final String parentEmail; // Pass the parent's email dynamically

  ParentHomeScreen({required this.userName, required this.parentEmail});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Header with avatar and name
          Container(
            color: Colors.green,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.04,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.08,
                  backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Text(
                    'Hello ${userName}', // Correct string interpolation
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Add Child Registration Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddChildScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                  child: const Text('+ Add Child'),
                ),
              ],
            ),
          ),


          // Body Content: Fetch and display child data
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('parentEmail', isEqualTo: parentEmail)
                  .where('role', isEqualTo: 'child') // Filter for children
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No data found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          'First add child',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                // Display list of children
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var childData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return Container(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              childData['name'], // Child's name
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${childData['age']} years', // Child's age
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
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
}*/




