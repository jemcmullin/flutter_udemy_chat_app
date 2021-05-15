import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String userId;
  final String username;
  final String imageUrl;
  final String message;
  final bool isCurrentUser;

  const MessageBubble({
    Key? key,
    required this.userId,
    required this.username,
    required this.imageUrl,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);

  // Future<String> getUsername() async {
  //   FutureBuilder<Object>(
  //       future:
  //           FirebaseFirestore.instance.collection('users').doc(userId).get(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Text('Loading...');
  //         }
  //         final userData = snapshot.data as Map<String, String>;
  //         return Text(userData['username']);
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 8.0),
                  child: Text(username)
                  // FutureBuilder<DocumentSnapshot>(
                  // future: FirebaseFirestore.instance
                  //     .collection('users')
                  //     .doc(userId)
                  //     .get(),
                  // builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  //   if (snapshot.hasError) {
                  //     return Text("Something went wrong");
                  //   }

                  //   if (snapshot.hasData && !snapshot.data!.exists) {
                  //     return Text("User does not exist");
                  //   }

                  //   if (snapshot.connectionState == ConnectionState.done) {
                  //     final userData =
                  //         snapshot.data!.data() as Map<String, dynamic>;
                  //     return Text(userData['username']);
                  //   }

                  //   return Text("loading...");
                  // }),
                  ),
              Row(
                mainAxisAlignment: isCurrentUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                        color: isCurrentUser
                            ? Colors.grey[400]
                            : Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft:
                              isCurrentUser ? Radius.circular(8) : Radius.zero,
                          bottomRight:
                              !isCurrentUser ? Radius.circular(8) : Radius.zero,
                        )),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: isCurrentUser
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline1
                                ?.color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            left:
                isCurrentUser ? null : MediaQuery.of(context).size.width * 0.45,
            right:
                isCurrentUser ? MediaQuery.of(context).size.width * 0.45 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
        ],
      ),
    );
  }
}
