import 'package:final_year_project/Parent_pages/kid_register.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentHome extends StatelessWidget {
  final String userName;
  final String parentEmail;

  const ParentHome({
    required this.userName,
    required this.parentEmail,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Section
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Hello, $userName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
 Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddChildScreen()),  // Navigate to the login screen
    );




                    

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('+ Add Child'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Child List Section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('parentEmail', isEqualTo: parentEmail)
                  .where('role', isEqualTo: 'child')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                       SizedBox(height: 20),
                       Text(
                        'No children data available.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var child = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          child['name'] ?? 'No Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Age: ${child['age'] ?? 'Unknown'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            // Add edit child functionality
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
