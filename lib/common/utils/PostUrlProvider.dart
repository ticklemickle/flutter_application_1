import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // 웹에서만 사용할 수 있는 패키지

class PostUrlProvider {
  // 전역 변수로 URL을 저장할 변수
  static String postUrl = '';

  // 앱 시작 시 한 번만 호출하여 postUrl을 설정하도록
  static void initialize(String postId) {
    if (kIsWeb) {
      // 웹 환경에서는 window.location을 이용해 동적으로 port를 처리
      final String host = html.window.location.hostname.toString();
      final String port = html.window.location.port.isEmpty
          ? ''
          : ':${html.window.location.port}';
      postUrl = '$host$port/viewPost/$postId'; // 현재 포트 번호를 포함한 URL
      print("Current postUrl: " + postUrl);
    } else {
      // 앱 환경에서는 딥 링크를 사용
      postUrl = 'tmapp://viewPost/$postId'; // 앱 내에서 동작할 URL 스킴
    }
  }

  // postUrl을 가져오는 메소드
  static String getPostUrl() {
    return postUrl;
  }
}
