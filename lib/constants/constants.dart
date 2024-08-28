import 'package:flutter/material.dart';
import 'package:vitium/screens/login_screen/login_screen.dart';
import 'package:vitium/screens/splash_screens/components/splash_screen.dart';
import 'package:vitium/screens/splash_screens/splash_screens.dart';

Color kPrimaryColor = Colors.orange;
Color kVitiumNameColor = const Color.fromRGBO(34, 121, 168, 1);
const String kBriefSplahs = 'assets/images/brief_splash.png';
const String kVitiumLogo = 'assets/images/vitium_logo.png';
Color kLetterColor = Colors.grey;
Color kSecondaryColor = const Color.fromRGBO(37, 74, 176, 1);
Color kTercearyColor = const Color.fromRGBO(66, 116, 252, 1);
final splashPages = <Widget>[
  const SplashScreen(
    'Encuentra tu\ntrabajo ideal\ncon nosotros',
    'Explora en las múltiples opciones que tenemos para ti',
  ),
  const SplashScreen(
    'Nada es\nimpedimento\naquí',
    'Somos fieles creyentes del potencial de los individuos, únete con nosotros',
  ),
  const SplashScreen(
    'Se un pilar\nen tu empresa\nsoñada',
    'Vuélvete nuestro socio y compleméntate en tu empresa ideal',
    whithButton: true,
  ),
];
final declarationOfRoutes = {
  '/splash': (context) => const SplashScreens(),
  '/login': (context) => const LoginScreen(),
};
