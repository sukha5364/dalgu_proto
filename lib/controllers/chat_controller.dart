// lib/controllers/chat_controller.dart
import 'dart:convert';
import 'package:dalgu_kakao_prototype/models/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dalgu_kakao_prototype/providers/providers.dart';

final chatControllerProvider = Provider((ref) => ChatController(ref: ref));

class ChatController {
  final Ref _ref;
  ChatController({required Ref ref}) : _ref = ref;

  static const _systemPrompt =
      '당신은 달서구 주민의 공공서비스 이용을 돕는 비서 달구입니다. 제공된 함수만 사용하여 필요한 정보를 찾아주세요.';

  Future<void> sendMessage(String userInput) async {
    final chatNotifier = _ref.read(chatMessagesProvider.notifier);
    final isLoadingNotifier = _ref.read(isLoadingProvider.notifier);

    final trimmed = userInput.trim();
    if (trimmed.isEmpty) return;

    // 1. 사용자 메시지 UI에 추가 및 로딩 시작
    isLoadingNotifier.state = true;
    chatNotifier.addMessage(
        ChatMessage(content: trimmed, role: MessageRole.user, timestamp: DateTime.now()));

    try {
      final openAIService = _ref.read(openAIServiceProvider);
      final localApiService = _ref.read(localApiServiceProvider);

      List<Map<String, dynamic>> conversationHistory = [
        {"role": "system", "content": _systemPrompt},
        ..._ref.read(chatMessagesProvider).map((msg) {
          return {"role": msg.role.name, "content": msg.content};
        })
      ];

      // 2. 1차 API 호출: 함수 사용 결정
      print("⏳ 1단계: GPT에게 어떤 API를 쓸지 물어보는 중...");
      final initialResponse = await openAIService.getChatCompletion(conversationHistory);
      if (initialResponse['error'] != null) throw Exception(initialResponse['error']);

      final choice = initialResponse['choices'][0]['message'];
      final toolCalls = choice['tool_calls'];

      // 3. GPT가 함수 호출을 결정한 경우
      if (toolCalls != null && toolCalls.isNotEmpty) {
        print("💡 GPT가 ${toolCalls.length}개의 API 사용을 결정했습니다.");
        conversationHistory.add(choice);

        // 4. 요청된 모든 함수를 실행
        for (var toolCall in toolCalls) {
          final functionName = toolCall['function']['name'];
          final args = jsonDecode(toolCall['function']['arguments']);
          String functionResponse;

          switch (functionName) {
            case 'bookChildcare':
              functionResponse = await localApiService.bookChildcare(date: args['date'], childName: args['childName'], location: args['location']);
              break;
            case 'reserveLibraryProgram':
              functionResponse = await localApiService.reserveLibraryProgram(programName: args['programName'], childName: args['childName'], date: args['date']);
              break;
            case 'scheduleHealthCenterVisit':
              functionResponse = await localApiService.scheduleHealthCenterVisit(patientName: args['patientName'], date: args['date'], department: args['department']);
              break;
            case 'bookOrientalClinic':
              functionResponse = await localApiService.bookOrientalClinic(patientName: args['patientName'], date: args['date'], treatment: args['treatment']);
              break;
            case 'requestNaduriCall':
              functionResponse = await localApiService.requestNaduriCall(passengerName: args['passengerName'], destination: args['destination'], time: args['time']);
              break;
            default:
              functionResponse = '{"error": "알 수 없는 함수입니다: $functionName"}';
          }

          conversationHistory.add({
            "tool_call_id": toolCall['id'],
            "role": "tool",
            "name": functionName,
            "content": functionResponse,
          });
        }

        // 5. 2차 API 호출: 함수 실행 결과 바탕으로 최종 답변 생성
        print("⏳ 2단계: API 실행 결과를 바탕으로 GPT에게 최종 답변 생성 요청 중...");
        final finalResponse = await openAIService.getChatCompletion(conversationHistory);
        if (finalResponse['error'] != null) throw Exception(finalResponse['error']);

        final finalContent = finalResponse['choices'][0]['message']['content'];
        chatNotifier.addMessage(ChatMessage(content: finalContent, role: MessageRole.assistant, timestamp: DateTime.now()));
      } else {
        // 함수 호출 없이 바로 답변
        print("💡 GPT가 API 사용 없이 바로 답변했습니다.");
        final content = choice['content'];
        chatNotifier.addMessage(ChatMessage(content: content, role: MessageRole.assistant, timestamp: DateTime.now()));
      }
    } catch (e) {
      chatNotifier.addMessage(ChatMessage(content: "오류가 발생했습니다: $e", role: MessageRole.assistant, timestamp: DateTime.now()));
    } finally {
      // 6. 로딩 종료
      isLoadingNotifier.state = false;
    }
  }
}