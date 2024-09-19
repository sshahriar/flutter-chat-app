import 'package:flutter/material.dart';
import 'package:whats_app1/colors.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final double maxWidth;
  final bool myMessage;

  const MessageCard({
    super.key,
    required this.message,
    required this.myMessage,
    this.backgroundColor = const Color(0xFFD9FDD3), // Default color
    this.maxWidth = 350, // Default max width
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: myMessage ? MainAxisAlignment.end : MainAxisAlignment.start ,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0), // Adjust padding if needed
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Card(
              color: myMessage ? myMessageColor : chatBackgroundColor ,
              elevation: 3, // Shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // Rounded corners
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0), // Padding inside the card
                child: Text(
                  message,
                  style: TextStyle(fontSize: 14),
                  softWrap: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
