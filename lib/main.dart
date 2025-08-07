// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dalgu_kakao_prototype/ui/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 에이전트 달구',
      theme: ThemeData(
        primaryColor: const Color(0xFF007DBC),
        fontFamily: 'Pretendard', // 시스템 폰트에 따라 적용 여부 다름
      ),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
