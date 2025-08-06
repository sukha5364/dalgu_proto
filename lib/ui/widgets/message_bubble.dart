// lib/ui/widgets/message_bubble.dart
import 'package:dalgu_kakao_prototype/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[
          const CircleAvatar(child: Text('달')),
          const SizedBox(width: 8),
        ],
        if (isUser)
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 4),
            child: Text(
              DateFormat('a h:mm', 'ko').format(message.timestamp),
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFFFFEB3B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.content,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
        ),
        if (!isUser)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(
              DateFormat('a h:mm', 'ko').format(message.timestamp),
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
      ],
    );
  }
}