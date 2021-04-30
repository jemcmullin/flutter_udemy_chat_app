import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udemy_chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('timeSent', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }

        final chatDocs = snapshot.data?.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs?.length ?? 0,
          itemBuilder: (context, index) => Container(
            // padding: NOW CONTROLLED BY MESSAGE BUBBLE
            child: MessageBubble(
              message: chatDocs?[index]['text'],
              isCurrentUser: chatDocs?[index]['userId'] ==
                  FirebaseAuth.instance.currentUser!.uid,
              key: ValueKey(chatDocs?[index].id),
            ),
          ),
        );
      },
    );
  }
}
