import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
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
          scaffoldBackgroundColor: MyColors.mainBackgroundColor,
          primarySwatch: Colors.blue,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: MyColors.grey, // 커서 색상
            selectionColor: MyColors.mainlightestColor, // 선택된 텍스트 배경 색상
            selectionHandleColor:
                MyColors.mainDarkColor, // 선택 핸들 색상 (드래그할 때 나오는 손잡이)
          ),
        ),
      ),
    );
  }
}
