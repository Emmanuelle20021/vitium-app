import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:vitium/app/data/implementation/firebase_auth_repository_implementation.dart';
import 'package:vitium/app/data/utils/injector.dart';
import 'package:vitium/app/presentation/bloc/bloc_provider.dart';
import 'package:vitium/app/presentation/bloc/exception_handler_cubit.dart';
import 'package:vitium/app/presentation/routes/app_routes.dart';
import 'app/presentation/routes/routes.dart';
import 'keys/firebase_options.dart';

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
      MaterialApp(
        home: Injector(
          accountRepository: FirebaseAuthRepositoryImplementation(
            firebaseAuth: FirebaseAuth.instance,
          ),
          child: BlocsProvider(
            child: Vitium(notFirstTime),
          ),
        ),
      ),
    );
  } catch (error) {
    /// Handle the error
    debugPrint('Error: $error');
  }
}

class Vitium extends StatelessWidget {
  const Vitium(this.notFirstTime, {super.key});
  final bool? notFirstTime;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return BlocConsumer<ExceptionHandlerCubit, ExceptionHandlerState>(
      listener: (context, state) {
        if (state.hasException && state.message != null) {
          toastification.show(
            context: context,
            title: const Text('Error'),
            description: Text(state.message!),
          );
        }
      },
      builder: (context, state) {
        return MaterialApp(
          initialRoute: notFirstTime == true
              ? Routes.homePostulant
              : Routes.splashScreens,
          routes: appRoutes,
        );
      },
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
                Navigator.pushNamed(context, Routes.login);
              },
              child: const Text('Go to Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.register);
              },
              child: const Text('Go to Register'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.postulantCreateProfile);
              },
              child: const Text('Go to Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.postulantsList);
              },
              child: const Text('Go to Postulants'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ExceptionHandlerCubit>().handleException(
                      Exception('Error'),
                      'Error Message',
                    );
              },
              child: const Text('Error Handler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.infoProfile);
              },
              child: const Text('Go to Info Profile'),
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
