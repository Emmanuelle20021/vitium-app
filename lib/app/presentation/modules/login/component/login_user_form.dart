import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:vitium/app/data/services/user_service.dart';
import 'package:vitium/app/presentation/bloc/register_cubit.dart';

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
  bool passwordVisible = true;
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
          Stack(
            children: [
              UnderlineInput(
                icon: Icons.lock_outline,
                hintText: '*********',
                label: const Text('Contraseña'),
                obscureText: passwordVisible,
                controller: passwordController,
                validator: Validators.validatePassword,
              ),
              Positioned(
                right: 0,
                child: Semantics(
                  button: true,
                  hint: 'Mostrar contraseña',
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    icon: Icon(
                      passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            child: TextButton(
              onPressed: () {},
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
    if (response.hasException && context.mounted) {
      toastification.show(
        context: context,
        title: const Text('Ups Algo salió mal'),
        description: const Text(
          'Revisa tus credenciales e intenta de nuevo',
        ),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    } else if (context.mounted) {
      final registerCubit = context.read<RegisterCubit>();
      final User user = response.data!;
      final userModel = await UserService.getUser(user.uid);
      if (userModel.data != null) registerCubit.setUser(userModel.data!);
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
      }
      if (context.mounted) {
        final registerCubit = context.read<RegisterCubit>();
        if (registerCubit.state.user.isComplete()) {
          Navigator.pushReplacementNamed(context, Routes.home);
        } else {
          Navigator.pushReplacementNamed(context, Routes.infoProfile);
        }
        toastification.show(
          context: context,
          title: Text('Bienvenido ${user.email}'),
          description: const Text('Iniciaste sesión correctamente en Vitium'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
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
