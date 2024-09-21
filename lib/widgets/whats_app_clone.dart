import 'package:flutter/material.dart';
import 'package:whats_app1/colors.dart';
import 'package:whats_app1/widgets/chat_view.dart';
import 'package:whats_app1/widgets/websocket_mock.dart';

class WhatsAppClone extends StatefulWidget {
  const WhatsAppClone({super.key});

  @override
  _WhatsAppCloneState createState() => _WhatsAppCloneState();
}

class _WhatsAppCloneState extends State<WhatsAppClone> {
  int _selectedIndex = 0;
  int selectedUser = 1;

  void _onIconButtonPressed(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: chatBackgroundColor,
        title: const Text(
          'Whatsapp',
          style: TextStyle(color: primaryColor),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
          IconButton(onPressed: () => throw Exception(), icon: const Icon(Icons.search)),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the selected item here
              if (value == 'User 1') {
                setState(() {
                  selectedUser = 1; // Update the selected index
                });
              } else if (value == 'User 2') {
                setState(() {
                  selectedUser = 2; // Update the selected index
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'User 2',
                  child: Text('User 2'),
                ),
                const PopupMenuItem<String>(
                  value: 'User 1',
                  child: Text('User 1'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert), // More options icon
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        child: ListView(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://uploads.dailydot.com/2018/10/olli-the-polite-cat.jpg?auto=compress%2Cformat&ixlib=php-3.3.0'),
                radius: 30,
              ),
              title: Text(
                selectedUser == 1 ? 'user2' : 'user1',
                style: const TextStyle(
                  fontSize: 16, // Increases font size
                  fontWeight: FontWeight.bold, // Makes text bold
                ),
              ),
              subtitle: const Text("hey there"),
              trailing: const Text("Yesterday"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => selectedUser == 1
                            ? const ChatView(
                                receiverId: 'user2',
                                loggedInUserId: 'user1',
                              )
                            : const ChatView(
                                receiverId: 'user1',
                                loggedInUserId: 'user2',
                              )));
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://uploads.dailydot.com/2018/10/olli-the-polite-cat.jpg?auto=compress%2Cformat&ixlib=php-3.3.0'),
                radius: 30,
              ),
              title: const Text(
                'Websocket ',
                style: TextStyle(
                  fontSize: 16, // Increases font size
                  fontWeight: FontWeight.bold, // Makes text bold
                ),
              ),
              subtitle: const Text("dfsfdsa f"),
              trailing: const Text("Yesterday"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebSocketMock()
                    ));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: BottomAppBar(
          color: chatBackgroundColor,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Distributes buttons evenly
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chat,
                      color: _selectedIndex == 0 ? primaryColor : Colors.black,
                    ),
                    onPressed: () {
                      _onIconButtonPressed(0);
                    },
                  ),
                  const Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 12, // Increases font size
                      fontWeight: FontWeight.bold, // Makes text bold
                    ),
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.groups_outlined,
                        color:
                            _selectedIndex == 1 ? primaryColor : Colors.black),
                    onPressed: () {
                      _onIconButtonPressed(1);
                    },
                  ),
                  const Text(
                    'Communities',
                    style: TextStyle(
                      fontSize: 12, // Increases font size
                      fontWeight: FontWeight.bold, // Makes text bold
                    ),
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.call,
                        color:
                            _selectedIndex == 2 ? primaryColor : Colors.black),
                    onPressed: () {
                      _onIconButtonPressed(2);
                    },
                  ),
                  const Text(
                    'Calls',
                    style: TextStyle(
                      fontSize: 12, // Increases font size
                      fontWeight: FontWeight.bold, // Makes text bold
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
