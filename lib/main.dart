import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/restartWidget.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_application_1/common/widgets/errorBoundary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RestartWidget(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp(
        title: '티끌미끌',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: AppRoutes.mainCommunity,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
