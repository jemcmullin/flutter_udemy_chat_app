import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }

        final chatDocs = snapshot.data?.docs;
        return ListView.builder(
          itemCount: chatDocs?.length ?? 0,
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.all(8),
            child: Text(chatDocs?[index]['text']),
          ),
        );
      },
    );
  }
}
