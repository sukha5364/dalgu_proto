// lib/ui/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dalgu_kakao_prototype/controllers/chat_controller.dart';
import 'package:dalgu_kakao_prototype/providers/providers.dart'; // 🚨 [수정] 이 부분을 수정했습니다.
import 'package:dalgu_kakao_prototype/ui/widgets/chat_input_field.dart';
import 'package:dalgu_kakao_prototype/ui/widgets/message_bubble.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFABC1D1), // 카카오톡 배경색과 유사
      appBar: AppBar(
        title: const Text('AI 에이전트 달구'),
        backgroundColor: const Color(0xFFABC1D1),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // 아래부터 메시지 쌓이도록
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // reverse이므로 역순으로 접근
                final message = messages[messages.length - 1 - index];
                return MessageBubble(message: message);
              },
            ),
          ),
          if (isLoading) const LinearProgressIndicator(),
          ChatInputField(
            onSendMessage: (text) {
              ref.read(chatControllerProvider).sendMessage(text);
            },
          ),
        ],
      ),
    );
  }
}