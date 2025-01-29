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

String formatRelativeTime(dynamic timestamp) {
  DateTime dateTime;

  if (timestamp is DateTime) {
    dateTime = timestamp;
  } else if (timestamp != null) {
    dateTime = timestamp.toDate();
  } else {
    return '';
  }

  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inMinutes < 1) {
    return '방금';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}일 전';
  } else if (difference.inDays < 30) {
    return '${difference.inDays ~/ 7}주 전';
  } else if (difference.inDays < 365) {
    return '${difference.inDays ~/ 30}달 전';
  } else {
    return '${difference.inDays ~/ 365}년 전';
  }
}
