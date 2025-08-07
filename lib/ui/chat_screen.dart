// lib/ui/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dalgu_kakao_prototype/controllers/chat_controller.dart';
import 'package:dalgu_kakao_prototype/providers/providers.dart';
import 'package:dalgu_kakao_prototype/ui/widgets/chat_input_field.dart';
import 'package:dalgu_kakao_prototype/ui/widgets/message_bubble.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 에이전트 달구'),
        backgroundColor: const Color(0xFF007DBC),
        leading: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Text('달', style: TextStyle(color: Color(0xFF007DBC))),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFABC1D1), Color(0xFFE2EBF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return MessageBubble(message: message);
                  },
                ),
              ),
              if (isLoading) const LinearProgressIndicator(minHeight: 2),
              ChatInputField(
                onSendMessage: (text) {
                  ref.read(chatControllerProvider).sendMessage(text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
