// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDalrLWJ83HVPeasYH59vZo6JJy7PD-Ok0',
    appId: '1:710336161491:web:6cffe90bc5711df2539626',
    messagingSenderId: '710336161491',
    projectId: 'ticklemickle',
    authDomain: 'ticklemickle.firebaseapp.com',
    storageBucket: 'ticklemickle.firebasestorage.app',
    measurementId: 'G-S7N8Z89W0F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_wHGNiCiOukPwGwgH2QpqlHGkbJoquSg',
    appId: '1:710336161491:android:dda45afe49781199539626',
    messagingSenderId: '710336161491',
    projectId: 'ticklemickle',
    storageBucket: 'ticklemickle.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-W5NPU3G8-Gtlx1zeh8BYRYUTxettZ40',
    appId: '1:710336161491:ios:ba6ecab5c6e0acd7539626',
    messagingSenderId: '710336161491',
    projectId: 'ticklemickle',
    storageBucket: 'ticklemickle.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
