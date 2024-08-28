import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:vitium/components/buttons/rectangle_button.dart';
import 'package:vitium/components/inputs/underline_input.dart';
import 'package:vitium/constants/constants.dart' as constants;
import 'package:vitium/services/auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Vitium',
              style: TextStyle(
                  color: constants.kVitiumNameColor,
                  fontFamily: 'Lato',
                  fontSize: 16),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Image(
                image: AssetImage(constants.kVitiumLogo),
                fit: BoxFit.scaleDown,
                height: 100,
              ),
            ),
            Text(
              '¡Bienvenido de vuelta!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: constants.kSecondaryColor,
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    UnderlineInput(
                      icon: Icons.person,
                      hintText: 'Email',
                      controller: emailController,
                      validator: validateEmail,
                    ),
                    UnderlineInput(
                      icon: Icons.lock,
                      hintText: 'Contraseña',
                      controller: passwordController,
                      //validator: validatePassword,
                    ),
                    RectangleButton(
                      child: const Text('Iniciar sesión'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signIn(
                            emailController.text,
                            passwordController.text,
                            context,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validateEmail(String? email) {
    final emailValidator = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
    );
    if (emailValidator.hasMatch(email!)) {
      return null;
    }
    return 'Please enter a valid email';
  }

  String? validatePassword(String? password) {
    //Minimo 8 caracteres
    //Maximo 15
    //Al menos una letra mayúscula
    //Al menos una letra minucula
    //Al menos un dígito
    //No espacios en blanco
    //Al menos 1 caracter especial
    final passwordValidator = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])([A-Za-z\d$@$!%*?&]|[^ ]){8,15}$',
    );
    if (passwordValidator.hasMatch(password!)) {
      return null;
    }
    return 'Please enter a valid password';
  }
}

void signIn(String email, String password, BuildContext context) async {
  // Sign in user
  User? user = await UserService().signInUser(
    email,
    password,
  );
  if (user == null) {
    debugPrint('User not found');
    return;
  } else if (context.mounted) {
    toastification.show(
      context: context,
      title: Text('Bienvenido ${user.email}'),
      description: const Text('Iniciaste sesión correctamente en Vitium'),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
  // Check if email is verified
  bool isEmailVerified = await UserService().checkEmailVerified();
  if (!isEmailVerified) {
    bool isEmailSended = await UserService().verifyEmail();
    debugPrint(
      isEmailSended ? 'Email verified sent' : 'Email verification not sent',
    );
    return;
  }
}
