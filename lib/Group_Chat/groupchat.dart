import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Firestore collection reference
  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('groupChats');

  // Current user details
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // Send a message
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _currentUser == null) return;

    final String userName = _currentUser!.email!.split('@')[0] ?? "Anonymous";
    final String messageText = _messageController.text.trim();

    try {
      // Document reference for the group chat
      final DocumentReference chatDocRef = _chatCollection.doc('29nRlKGzgqEnnpLC8dZ9');

      // Check if the document exists
      final DocumentSnapshot docSnapshot = await chatDocRef.get();
      if (!docSnapshot.exists) {
        print("Document does not exist.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message. Document not found.')),
        );
        return;
      }

      // Prepare the message data
      final messageData = {
        'senderName': userName,
        'text': messageText,
      };

      // Add the message to the group's message array
      await chatDocRef.update({
        'messages': FieldValue.arrayUnion([messageData]),
      });

      // Clear the message input field
      _messageController.clear();

      // Scroll to the bottom of the chat
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      print("Error sending message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Chat"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _chatCollection.doc('29nRlKGzgqEnnpLC8dZ9').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;
                if (data == null || data['messages'] == null) {
                  return Center(child: Text('No messages yet'));
                }

                final messages = List<Map<String, dynamic>>.from(data['messages']);
                final userName = _currentUser!.email!.split('@')[0] ?? "Anonymous";

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final text = msg['text'] ?? '';
                    final senderName = msg['senderName'] ?? 'Unknown';

                    return ListTile(
                      title: Text(
                        senderName,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      subtitle: Text(text),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
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
