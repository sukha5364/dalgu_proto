// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dalgu_kakao_prototype/main.dart'; // 🚨 [수정] 프로젝트 이름을 변경했습니다.

void main() {
  testWidgets('App starts and shows welcome message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that the initial welcome message from the assistant is present.
    expect(find.text('AI 에이전트 달구'), findsOneWidget);
    expect(find.textContaining('안녕하세요! AI 비서 달구입니다.'), findsOneWidget);
  });
}