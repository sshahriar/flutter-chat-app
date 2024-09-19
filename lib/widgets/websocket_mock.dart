import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketMock extends StatefulWidget {
  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketMock> {
 
  final WebSocketChannel channel =
      // WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));
       WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
      
 
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket Example"),
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
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData ? '${snapshot.data}' : 'No message yet.',
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
          ],
          
        ),
        
      ),
      //  floatingActionButton: FloatingActionButton(
      //   onPressed: _sendMessage,
      //   tooltip: 'Send message',
      //   child: const Icon(Icons.send),
      // ), 
      
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() { 
    channel.sink.close(status.goingAway);
    _controller.dispose();
    super.dispose();
  }
}
