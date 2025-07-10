import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final List chatMessages;
  final SocketService socketService;

  const ChatScreen({
    required this.chatMessages,
    required this.socketService,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = TextEditingController();

  void _sendMessage() {
    widget.socketService.sendMessage(_chatController.text);
    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: widget.chatMessages.length,
              // itemBuilder: (_, i) => ListTile(
              //   title: Text(widget.chatMessages[i].toString()),
              // ),
              itemBuilder: (_, i) {
                final msg = widget.chatMessages[i];
                return ListTile(
                  title: Text(msg['message'] ?? ''),
                  subtitle: Text(msg['timestamp'] ?? ''),
                );
              }),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _chatController,
                decoration: const InputDecoration(hintText: "Enter message"),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ],
    );
  }
}
