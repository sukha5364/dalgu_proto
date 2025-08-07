// lib/services/openai_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  OpenAIService();

  String get _apiKey {
    const key = String.fromEnvironment('OPENAI_API_KEY');
    if (key.isNotEmpty) return key;
    final envKey = dotenv.env['OPENAI_API_KEY'];
    if (envKey != null && envKey.isNotEmpty) return envKey;
    return Platform.environment['OPENAI_API_KEY'] ?? '';
  }

  Future<Map<String, dynamic>> getChatCompletion(
      List<Map<String, dynamic>> history) async {
    if (_apiKey.isEmpty) {
      return {'error': 'Missing OPENAI_API_KEY'};
    }

    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final body = {
      'model': 'o3',
      'messages': history,
      'temperature': 0.2,
      'max_tokens': 500,
      'tool_choice': 'auto',
      'tools': [
        {
          'type': 'function',
          'function': {
            'name': 'bookChildcare',
            'description': '아이돌봄 지원을 예약합니다.',
            'parameters': {
              'type': 'object',
              'properties': {
                'date': {'type': 'string', 'description': '예약 날짜'},
                'childName': {'type': 'string', 'description': '아동 이름'},
                'location': {'type': 'string', 'description': '돌봄 장소'},
              },
              'required': ['date', 'childName']
            }
          }
        },
        {
          'type': 'function',
          'function': {
            'name': 'reserveLibraryProgram',
            'description': '도서관 프로그램을 예약합니다.',
            'parameters': {
              'type': 'object',
              'properties': {
                'programName': {'type': 'string'},
                'childName': {'type': 'string'},
                'date': {'type': 'string'},
              },
              'required': ['programName', 'childName', 'date']
            }
          }
        },
        {
          'type': 'function',
          'function': {
            'name': 'scheduleHealthCenterVisit',
            'description': '보건소 진료를 예약합니다.',
            'parameters': {
              'type': 'object',
              'properties': {
                'patientName': {'type': 'string'},
                'date': {'type': 'string'},
                'department': {'type': 'string'},
              },
              'required': ['patientName', 'date', 'department']
            }
          }
        },
        {
          'type': 'function',
          'function': {
            'name': 'bookOrientalClinic',
            'description': '한방진료실 예약을 진행합니다.',
            'parameters': {
              'type': 'object',
              'properties': {
                'patientName': {'type': 'string'},
                'date': {'type': 'string'},
                'treatment': {'type': 'string'},
              },
              'required': ['patientName', 'date', 'treatment']
            }
          }
        },
        {
          'type': 'function',
          'function': {
            'name': 'requestNaduriCall',
            'description': '나드리콜을 호출합니다.',
            'parameters': {
              'type': 'object',
              'properties': {
                'passengerName': {'type': 'string'},
                'destination': {'type': 'string'},
                'time': {'type': 'string'},
              },
              'required': ['passengerName', 'destination', 'time']
            }
          }
        },
      ],
    };

    try {
      final response = await http.post(uri,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer ' + _apiKey,
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          'error':
              'Request failed: ${response.statusCode} ${response.reasonPhrase}'
        };
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
