import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KidsProfilePage extends StatefulWidget {
  @override
  _KidsProfilePageState createState() => _KidsProfilePageState();
}

class _KidsProfilePageState extends State<KidsProfilePage> {
  bool isEditing = false;

  final nameController = TextEditingController();
  final hobbyController = TextEditingController();
  final favoriteSubjectController = TextEditingController();
  String selectedGender = 'Male';
  String selectedAvatar = 'assets/kids_profile.png';

  @override
  void initState() {
    super.initState();
    fetchKidsProfile();
  }

  Future<void> fetchKidsProfile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference profileDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('child_profile');

      DocumentSnapshot profileSnapshot = await profileDoc.get();

      if (profileSnapshot.exists) {
        Map<String, dynamic> profileData = profileSnapshot.data() as Map<String, dynamic>;

        // Use setState to update the UI after fetching the data
        setState(() {
          nameController.text = profileData['name'] ?? 'Charlie';
          hobbyController.text = profileData['hobby'] ?? 'Playing puzzles';
          favoriteSubjectController.text = profileData['favorite_subject'] ?? 'Math';
          selectedGender = profileData['gender'] ?? 'Male';
          selectedAvatar = profileData['avatar'] ?? 'assets/kids_profile.png';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No profile data found!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    }
  }


  Future<void> saveKidsProfile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference profileDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('child_profile');

      Map<String, dynamic> profileData = {
        'name': nameController.text.trim(),
        'favorite_subject': favoriteSubjectController.text.trim(),
        'gender': selectedGender,
        'hobby': hobbyController.text.trim(),
        'avatar': selectedAvatar,
      };

      await profileDoc.set(profileData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved successfully!')),
      );

      setState(() {
        isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }

  void _showAvatarSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an Avatar'),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                String avatarUrl = 'assets/kids/avatars/avatar_$index.png';
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatar = avatarUrl; // Update selected avatar
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Image.asset(avatarUrl, fit: BoxFit.cover),
                );
              },
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFa3b68a),
      appBar: AppBar(
        backgroundColor: Color(0xFFa3b68a),
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'ComicSans',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Stack(
              children: [
                Container(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.yellow[200]!, width: 5),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      selectedAvatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, size: 30),
                      onPressed: () {
                        _showAvatarSelectionDialog(context);
                      },
                    ),
                  ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            isEditing
                ? Padding(
              padding:
              EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: TextFormField(
                controller: nameController,
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  fontFamily: 'ComicSans',
                ),
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            )
                : Text(
              nameController.text,
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
                fontFamily: 'ComicSans',
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Color(0xFFfaf0e6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.subject,
                          color: Colors.purple, size: screenWidth * 0.08),
                      title: isEditing
                          ? TextFormField(
                        controller: favoriteSubjectController,
                        decoration: InputDecoration(
                          labelText: 'Favorite Subject',
                          border: OutlineInputBorder(),
                        ),
                      )
                          : Text(favoriteSubjectController.text),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person,
                          color: Colors.green, size: screenWidth * 0.08),
                      title: Text('Gender'),
                      trailing: isEditing
                          ? DropdownButton<String>(
                        value: selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      )
                          : Text(selectedGender),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.sports_esports,
                          color: Colors.orange, size: screenWidth * 0.08),
                      title: isEditing
                          ? TextFormField(
                        controller: hobbyController,
                        decoration: InputDecoration(
                          labelText: 'Hobby',
                          border: OutlineInputBorder(),
                        ),
                      )
                          : Text(hobbyController.text),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
              child: ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    saveKidsProfile();
                  }
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(isEditing ? 'Save' : 'Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
