import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitium/components/buttons/rectangle_button.dart';
import 'package:vitium/constants/constants.dart';
import 'package:vitium/models/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen(
    this.title,
    this.text, {
    super.key,
    this.whithButton = false,
  });
  final String title;
  final String text;
  final bool whithButton;

  @override
  Widget build(BuildContext context) {
    List<String> splitted = title.split('\n');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Image.asset(kBriefSplahs, fit: BoxFit.contain),
                ),
              ),
              _builtTitle(splitted),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  text,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kLetterColor,
                  ),
                ),
              ),
              if (whithButton)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: RectangleButton(
                    onPressed: () {
                      _finishSplash(context);
                    },
                    child: const Text('Aceptar'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _finishSplash(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSaved = await prefs.setBool('notFirstTime', true);
    if (isSaved && context.mounted) {
      Navigator.pushReplacementNamed(
        context,
        VitiumRoutes.loginScreen,
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar la configuración'),
        ),
      );
    }
  }

  Widget _builtTitle(List<String> splitted) {
    return Column(
      children: [
        ...List.generate(
          splitted.length,
          (index) => Text(
            splitted[index],
            style: TextStyle(
              color: (index % 2) == 1 ? kPrimaryColor : Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
