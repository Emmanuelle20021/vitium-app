import 'package:flutter/material.dart';
import 'package:vitium/app/presentation/modules/splash/component/splash_page.dart';

Color kPrimaryColor = Colors.orange;
Color kVitiumNameColor = const Color.fromRGBO(34, 121, 168, 1);
const String kBriefSplahs = 'assets/images/brief_splash.png';
const String kVitiumLogo = 'assets/images/vitium_logo.png';
Color kLetterColor = Colors.grey;
Color kSecondaryColor = const Color.fromRGBO(37, 74, 176, 1);
Color kTercearyColor = const Color.fromRGBO(66, 116, 252, 1);
double kPadding = 16.0;
final splashPages = <Widget>[
  const SplashPage(
    'Encuentra tu\ntrabajo ideal\ncon nosotros',
    'Explora en las múltiples opciones que tenemos para ti',
  ),
  const SplashPage(
    'Nada es\nimpedimento\naquí',
    'Somos fieles creyentes del potencial de los individuos, únete con nosotros',
  ),
  const SplashPage(
    'Se un pilar\nen tu empresa\nsoñada',
    'Vuélvete nuestro socio y compleméntate en tu empresa ideal',
    whithButton: true,
  ),
];
get kInputLabelStyle => const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

get kAppBarWithName => AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'VITIUM',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
