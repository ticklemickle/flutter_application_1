import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/commonScaffold.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '티끌미끌',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.mainCommunity,
      routes: AppRoutes.getRoutes(),
      builder: (context, child) {
        // 상태 표시줄 여백 공통 적용
        return CommonScaffold(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
