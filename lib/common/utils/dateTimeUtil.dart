import 'package:intl/intl.dart'; // intl 패키지 임포트

// Firestore 타임스탬프를 yyyy-MM-dd HH:mm:ss 형식으로 변환
String formatTimestamp(dynamic timestamp) {
  if (timestamp is DateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);
  } else if (timestamp != null) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate());
  }
  return '';
}
