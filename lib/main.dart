import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'ui/chat_screen.dart'; // 여러분 프로젝트의 첫 화면 위젯

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) .env 로드 (OPENAI_API_KEY 등)
  await dotenv.load();

  // 2) Intl 로케일 데이터 초기화 – 날짜‧시간 포맷 예외 방지
  await initializeDateFormatting('ko');      // 원하는 로케일 코드
  Intl.defaultLocale = 'ko';                 // DateFormat() 쓸 때 매번 넣지 않아도 됨

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dalgu Prototype',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
