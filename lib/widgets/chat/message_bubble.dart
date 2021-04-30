import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
              color: isCurrentUser
                  ? Colors.grey[400]
                  : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: isCurrentUser ? Radius.circular(8) : Radius.zero,
                bottomRight: !isCurrentUser ? Radius.circular(8) : Radius.zero,
              )),
          child: Text(
            message,
            style: TextStyle(
              color: isCurrentUser
                  ? Colors.black
                  : Theme.of(context).accentTextTheme.headline1?.color,
            ),
          ),
        ),
      ],
    );
  }
}
