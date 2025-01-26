import 'package:firebase_messaging/firebase_messaging.dart';

class FCMRepository {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initializeFCM() async {
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground message received: ${message.notification?.title}');
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      print('Background message received: ${message.notification?.title}');
    });
  }
}
