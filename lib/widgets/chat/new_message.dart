import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _messageText = '';
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final _user = FirebaseAuth.instance.currentUser;
    final _userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _messageText,
      'timeSent': Timestamp.now(),
      'userId': _user.uid,
      'username': _userData['username'],
      'imageUrl': _userData['image_url'],
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Send a message...',
              ),
              onChanged: (value) {
                setState(() {
                  _messageText = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _messageText.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
