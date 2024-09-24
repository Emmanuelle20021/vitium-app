import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/utils/injector.dart';
import '../../../../data/utils/validators.dart';
import '../../../../domain/models/async_response.dart';
import '../../../../domain/repository/account_repository.dart';
import '../../../global/components/buttons/rectangle_button.dart';
import '../../../global/components/inputs/underline_input.dart';
import '../../../routes/routes.dart';

class FormLoginUser extends StatefulWidget {
  const FormLoginUser({super.key});

  @override
  State<FormLoginUser> createState() => _FormLoginUserState();
}

class _FormLoginUserState extends State<FormLoginUser> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          UnderlineInput(
            icon: Icons.person,
            hintText: 'emma20021@gmail.com',
            controller: emailController,
            validator: Validators.validateEmail,
            label: const Text('Correo Electrónico'),
          ),
          UnderlineInput(
            label: const Text('Contraseña'),
            icon: Icons.lock,
            hintText: '*******',
            controller: passwordController,
            validator: Validators.validatePassword,
            obscureText: true,
          ),
          SizedBox(
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.register);
              },
              child: const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
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
    );
  }

  void signIn(String email, String password, BuildContext context) async {
    // Sign in user
    AccountRepository accountRepository =
        Injector.of(context).accountRepository;
    final response = await accountRepository.login(
      email,
      password,
    );
    if (response.hasException) {
      debugPrint('User not found');
      return;
    } else if (context.mounted) {
      final User user = response.data!;
      toastification.show(
        context: context,
        title: Text('Bienvenido ${user.email}'),
        description: const Text('Iniciaste sesión correctamente en Vitium'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      Navigator.pushNamed(context, Routes.homePostulant);
    }
    // Check if email is verified
    AsyncResponse isEmailVerified =
        await accountRepository.checkEmailVerified();
    if (isEmailVerified.hasException) {
      debugPrint('Error: ${isEmailVerified.exception}');
      return;
    }
    if (!isEmailVerified.data) {
      AsyncResponse isEmailSended =
          await accountRepository.sendEmailVerification();
      debugPrint(
        isEmailSended.data
            ? 'Email verified sent'
            : 'Email verification not sent',
      );
      return;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
