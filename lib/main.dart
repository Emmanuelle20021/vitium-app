import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitium/constants/constants.dart' as constants;
import 'package:vitium/models/routes.dart';
import 'package:vitium/screens/login_screen/login_screen.dart';
import 'package:vitium/screens/postulant_create_profile_screen.dart';
import 'package:vitium/screens/postulants_list_screen.dart';
import 'package:vitium/screens/register_screen.dart';
import 'firebase_options.dart';

FirebaseApp? firebase;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final bool? notFirstTime = prefs.getBool('notFirstTime');
    runApp(
      Vitium(notFirstTime),
    );
  } catch (error) {
    /// Handle the error
    debugPrint('Error: $error');
  }
}

class Vitium extends StatelessWidget {
  const Vitium(this.notFirstTime, {super.key});
  final bool? notFirstTime;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      initialRoute: notFirstTime != null
          ? VitiumRoutes.splashScreens
          : VitiumRoutes.loginScreen,
      routes: constants.declarationOfRoutes,
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _removePreferences,
              child: const Text('Quitar Preferencias'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Go to Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Go to Register'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostulantCreateProfileScreen(),
                  ),
                );
              },
              child: const Text('Go to Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostulantListScreen(),
                  ),
                );
              },
              child: const Text('Go to Postulants'),
            ),
          ],
        ),
      ),
    );
  }

  void _removePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('notFirstTime');
  }
}
