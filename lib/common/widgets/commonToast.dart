// toast_helper.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';

void showToast(BuildContext context, String message) {
  // 웹에서는 fluttertoast 대신 ScaffoldMessenger 사용
  if (kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } else {
    Fluttertoast.showToast(msg: message); // 네이티브 플랫폼에서 fluttertoast 사용
  }
}
