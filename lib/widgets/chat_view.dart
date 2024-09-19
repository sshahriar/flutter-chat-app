import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whats_app1/colors.dart';
import 'package:whats_app1/services/firebase_service.dart';
import 'package:whats_app1/widgets/message_card.dart';

class ChatView extends StatefulWidget {
  final String receiverId;
  final String loggedInUserId;
  
  const ChatView({super.key, required this.receiverId, required this.loggedInUserId});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  // String loggedInUserId = widget.loggedInUserId;
    

  void _sendMessage() {
    final message = _messageController.text;
    _firebaseService.addMessageToFirebase(widget.loggedInUserId, widget.receiverId, message);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: chatBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous page
          },
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://uploads.dailydot.com/2018/10/olli-the-polite-cat.jpg?auto=compress%2Cformat&ixlib=php-3.3.0'),
              radius: 15,
            ),
            SizedBox(width: 12),
            Text(
              widget.receiverId,
              style: const TextStyle(
                fontSize: 15, // Increases font size
                fontWeight: FontWeight.bold, // Makes text bold
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.videocam_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _firebaseService.getMessagesStream(widget.loggedInUserId, widget.receiverId), // Stream of messages
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages found'));
                }

                // Fetch messages from the stream
                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    print("messeges ====>  $messageData");
                    // print();
                    return MessageCard(
                      message: messageData['message'], 
                      myMessage: messageData['userId'] == widget.loggedInUserId
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                      hintText: 'Message',
                      filled: true, // Enables the background color
                      fillColor: chatBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Set the border radius here
                        borderSide: BorderSide
                            .none, // No border side if you want no outline
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      prefixIcon: Icon(Icons.emoji_emotions_outlined),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.attach_file), // Attachment icon
                        onPressed: () {
                          // Handle attachment action
                          print('Attachment icon clicked');
                        },
                      )),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                // Handle the send action
                _sendMessage();
                print('Send message: ${_messageController.text}');
                _messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
