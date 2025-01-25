import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '게시판 앱',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.mainCommunity,
      routes: AppRoutes.getRoutes(),
    );
  }
}
