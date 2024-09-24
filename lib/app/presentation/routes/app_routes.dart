import 'package:flutter/material.dart';
import 'package:vitium/main.dart';

import '../modules/login/screen/login_screen.dart';
import '../modules/postulant/screen/postulant_create_profile_screen.dart';
import '../modules/postulant/screen/postulants_list_screen.dart';
import '../modules/profile/screen/info_profile_screen.dart';
import '../modules/signup/screen/register_screen.dart';
import '../modules/splash/screen/splash_screens.dart';
import 'routes.dart';

Map<String, Widget Function(BuildContext context)> get appRoutes => {
      Routes.homePostulant: (context) => const HomeWidget(),
      Routes.login: (context) => const LoginScreen(),
      Routes.register: (context) => const RegisterScreen(),
      Routes.splashScreens: (context) => const SplashScreens(),
      Routes.postulantCreateProfile: (context) =>
          const PostulantCreateProfileScreen(),
      Routes.postulantsList: (context) => const PostulantListScreen(),
      Routes.infoProfile: (context) => const InfoProfileScreen(),
    };
