// lib/ui/widgets/chat_input_field.dart
import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final Function(String) onSendMessage;
  const ChatInputField({super.key, required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    void _handleSend() {
      if (textController.text.trim().isNotEmpty) {
        onSendMessage(textController.text.trim());
        textController.clear();
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      color: Colors.transparent,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                onSubmitted: (_) => _handleSend(),
                decoration: InputDecoration(
                  hintText: '메시지를 입력하세요',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 5,
                minLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _handleSend,
              child: const CircleAvatar(
                backgroundColor: Color(0xFF007DBC),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
