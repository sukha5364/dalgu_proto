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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                onSubmitted: (_) => _handleSend(),
                decoration: InputDecoration(
                  hintText: '메시지를 입력하세요',
                  fillColor: Colors.grey[100],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 5,
                minLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}