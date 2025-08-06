// lib/providers/providers.dart
import 'package:dalgu_kakao_prototype/models/chat_message.dart';
import 'package:dalgu_kakao_prototype/services/local_api_service.dart';
import 'package:dalgu_kakao_prototype/services/openai_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Service Providers
final openAIServiceProvider = Provider((ref) => OpenAIService());
final localApiServiceProvider = Provider((ref) => LocalApiService());

// Chat State Providers
final chatMessagesProvider = StateNotifierProvider<ChatMessageNotifier, List<ChatMessage>>((ref) {
  return ChatMessageNotifier();
});

final isLoadingProvider = StateProvider<bool>((ref) => false);

// ChatMessage Notifier Class
class ChatMessageNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessageNotifier() : super([
    ChatMessage(content: '안녕하세요! AI 비서 달구입니다.\n달서구의 모든 공공서비스, 저에게 물어보세요!', role: MessageRole.assistant, timestamp: DateTime.now())
  ]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }
}