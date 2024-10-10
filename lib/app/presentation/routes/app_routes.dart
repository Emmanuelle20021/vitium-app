import 'package:flutter/material.dart';
import 'package:vitium/app/presentation/modules/home/screen/home_screen.dart';

import '../modules/login/screen/login_screen.dart';
import '../modules/profile/screen/info_profile_screen.dart';
import '../modules/register/screen/register_screen.dart';
import '../modules/splash/screen/splash_screens.dart';
import 'routes.dart';

Map<String, Widget Function(BuildContext context)> get appRoutes => {
      Routes.home: (context) => const HomeScreen(),
      Routes.login: (context) => const LoginScreen(),
      Routes.register: (context) => const RegisterScreen(),
      Routes.splashScreens: (context) => const SplashScreens(),
      Routes.postulantCreateProfile: (context) => const Center(),
      Routes.postulantsList: (context) => const Center(),
      Routes.infoProfile: (context) => const InfoProfileScreen(),
    };
