import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/main/main_community_screen.dart';
import 'package:flutter_application_1/pages/main/main_muscle_screen.dart';
import 'package:flutter_application_1/pages/main/main_setting_screen.dart';
import 'package:flutter_application_1/pages/my_info/my_info_screen.dart';
import 'package:flutter_application_1/pages/post/add_post_screen.dart';
import 'package:flutter_application_1/pages/post/view_post_screen.dart';

class AppRoutes {
  static const String mainCommunity = '/mainCommunity';
  static const String mainMuscle = '/mainMuscle';
  static const String mainSetting = '/mainSetting';
  static const String myInfo = '/myInfo';
  static const String viewPost = '/viewPost';
  static const String addPost = '/addPost';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      mainCommunity: (context) => const MainCommunityScreen(),
      mainMuscle: (context) => const MainMuscleScreen(),
      mainSetting: (context) => const MainSettingScreen(),
      myInfo: (context) => const MyInfoScreen(),
      viewPost: (context) => const ViewPostScreen(),
      addPost: (context) => const AddPostScreen(),
    };
  }
}
