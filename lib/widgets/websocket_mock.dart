import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:whats_app1/widgets/message_card.dart';

class WebSocketMock extends StatefulWidget {
  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketMock> {
  final WebSocketChannel channel =
      // WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));
      // WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
      WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080'));

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ws://10.0.2.2:8080"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Send a message"),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text("Send Message"),
            ),
            SizedBox(height: 24),
            // ElevatedButton(
            //   onPressed: () {
            //     try {
            //       throw Exception('Test Exception');
            //     } catch (e, stackTrace) {
            //       FirebaseCrashlytics.instance
            //           .recordError(e, stackTrace, reason: 'Test exception');
            //     }
            //   },
            //   child: Text("Throw Exception"),
            // ),
            SizedBox(height: 24),
            Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: channel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var messages = jsonDecode(snapshot.data as String);
                  
                        print('data =>  $messages');
                  
                        return ListView.builder(
                          itemCount: messages.length, // Number of messages to display
                          itemBuilder: (context, index) {
                            // Extract the current message
                            String message = messages[index]['msg'];
                            int userId = messages[index]['userId'];
                            String time = messages[index]['time'];
                  
                            // Display each message in a ListTile
                            return ListTile(
                              title: Text('User $userId: $message'),
                              subtitle: Text('Sent at: $time'),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text('No data yet...');
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    print("button pressed");
    if (_controller.text.isNotEmpty) {
      final message = {
        'msg': _controller.text,
        'userId': 1234,
        'time': DateTime.now().toString(),
      };

      final messageJson = jsonEncode(message);

      channel.sink.add(messageJson);
    }
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    _controller.dispose();
    super.dispose();
  }
}
