import 'package:flutter_application_1/pages/main/main_community_screen.dart';
import 'package:flutter_application_1/pages/main/main_muscle_screen.dart';
import 'package:flutter_application_1/pages/main/main_setting_screen.dart';
import 'package:flutter_application_1/pages/my_info/my_info_screen.dart';
import 'package:flutter_application_1/pages/post/add_post_screen.dart';
import 'package:flutter_application_1/pages/post/view_post_screen.dart';

import 'package:go_router/go_router.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/mainCommunity',
    routes: [
      GoRoute(
        path: '/mainCommunity',
        builder: (context, state) => const MainCommunityScreen(),
      ),
      GoRoute(
        path: '/mainMuscle',
        builder: (context, state) => const MainMuscleScreen(),
      ),
      GoRoute(
        path: '/mainSetting',
        builder: (context, state) => const MainSettingScreen(),
      ),
      GoRoute(
        path: '/myInfo',
        builder: (context, state) => const MyInfoScreen(),
      ),
      GoRoute(
        path: '/viewPost/:id', // URL에 매개변수 포함
        builder: (context, state) {
          final String id = state.pathParameters['id']!; // URL 매개변수에서 id 가져오기
          return ViewPostScreen(postId: id);
        },
      ),
      GoRoute(
        path: '/addPost',
        builder: (context, state) => const AddPostScreen(),
      ),
    ],
  );
}
