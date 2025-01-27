import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/restartWidget.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({Key? key, required this.child}) : super(key: key);

  @override
  _ErrorBoundaryState createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;

  void _handleError(FlutterErrorDetails details) {
    // FlutterError.onError로 전달된 에러를 처리
    setState(() {
      hasError = true;
    });
  }

  @override
  void initState() {
    super.initState();
    FlutterError.onError = _handleError;
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      // 에러 발생 시 앱을 재시작
      WidgetsBinding.instance.addPostFrameCallback((_) {
        RestartWidget.restartApp(context); // 앱 재시작 호출
      });
      return const SizedBox.shrink(); // 빈 화면 반환 (UI 깜빡임 방지)
    }

    return widget.child; // 정상 상태일 때 원래 child 위젯을 반환
  }

  @override
  void dispose() {
    // dispose에서 FlutterError 핸들러를 초기 상태로 복구
    FlutterError.onError = FlutterError.dumpErrorToConsole;
    super.dispose();
  }
}
