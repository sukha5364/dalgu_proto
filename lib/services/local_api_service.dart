// lib/services/local_api_service.dart
import 'dart:convert';

class LocalApiService {
  Future<String> bookChildcare({required String date, required String childName, String? location}) async {
    print("✅ [가상 API] 아이돌봄 예약: 날짜($date), 아동명($childName), 장소(${location ?? '미지정'})");
    await Future.delayed(const Duration(milliseconds: 300));
    return jsonEncode({"status": "예약 완료", "service": "아이돌봄 지원", "details": "$date, ${childName} 아동 돌봄 예약이 완료되었습니다."});
  }

  Future<String> reserveLibraryProgram({required String programName, required String childName, required String date}) async {
    print("✅ [가상 API] 도서관 프로그램 예약: 프로그램명($programName), 아동명($childName), 날짜($date)");
    await Future.delayed(const Duration(milliseconds: 300));
    return jsonEncode({"status": "예약 완료", "service": "도서관 체험학습", "details": "'$programName' 프로그램에 ${childName} 아동의 예약이 완료되었습니다."});
  }

  Future<String> scheduleHealthCenterVisit({required String patientName, required String date, required String department}) async {
    print("✅ [가상 API] 보건소 예약: 환자명($patientName), 날짜($date), 진료과($department)");
    await Future.delayed(const Duration(milliseconds: 300));
    return jsonEncode({"status": "예약 완료", "service": "보건소 진료", "details": "${patientName}님의 ${department} 진료가 ${date}로 예약되었습니다."});
  }

  Future<String> bookOrientalClinic({required String patientName, required String date, required String treatment}) async {
    print("✅ [가상 API] 한방진료실 예약: 환자명($patientName), 날짜($date), 치료($treatment)");
    await Future.delayed(const Duration(milliseconds: 300));
    return jsonEncode({"status": "예약 완료", "service": "한방진료실", "details": "${patientName}님의 ${treatment} 한방진료 예약이 ${date}로 완료되었습니다."});
  }

  Future<String> requestNaduriCall({required String passengerName, required String destination, required String time}) async {
    print("✅ [가상 API] 나드리콜 예약: 탑승자($passengerName), 목적지($destination), 시간($time)");
    await Future.delayed(const Duration(milliseconds: 300));
    return jsonEncode({"status": "호출 완료", "service": "나드리콜", "details": "${passengerName}님을 위해 ${time}에 ${destination}(으)로 가는 나드리콜 호출을 완료했습니다."});
  }
}