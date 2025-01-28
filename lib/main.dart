import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/utils/PostUrlProvider.dart';
import 'package:flutter_application_1/common/widgets/restartWidget.dart';
import 'package:url_strategy/url_strategy.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_application_1/common/widgets/errorBoundary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy(); //Url 에서 #을 제거
  PostUrlProvider.initialize(''); //공유하기 위해서 Url을 설정
  runApp(const RestartWidget(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp.router(
        routerConfig: AppRoutes.router,
        title: '티끌미끌',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
