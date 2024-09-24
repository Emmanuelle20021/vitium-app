import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:vitium/app/data/utils/validators.dart';
import 'package:vitium/app/presentation/global/components/buttons/rectangle_button.dart';

import '../../../global/components/inputs/underline_input.dart';

class RegisterUserForm extends StatefulWidget {
  const RegisterUserForm({super.key});

  @override
  State<RegisterUserForm> createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  bool isPostulant = true;
  bool passwordVisible = true;

  late GlobalKey<FormState> _formKey;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UnderlineInput(
              icon: Icons.person_2_outlined,
              hintText: 'correoPrueba123@gmail.com',
              label: const Text('Correo Electrónico'),
              controller: _emailController,
              validator: Validators.validateEmail,
            ),
            Stack(
              children: [
                UnderlineInput(
                  icon: Icons.lock_outline,
                  hintText: '*********',
                  label: const Text('Contraseña'),
                  obscureText: passwordVisible,
                  controller: _passwordController,
                  validator: Validators.validatePassword,
                ),
                Positioned(
                  right: 0,
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
              ],
            ),
            UnderlineInput(
              icon: Icons.lock_outline,
              hintText: '*********',
              label: const Text('Confirmar contraseña'),
              obscureText: passwordVisible,
              controller: _confirmPasswordController,
              validator: (passwordConfirmation) {
                if (passwordConfirmation != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
            RectangleButton(
              onPressed: _register,
              child: const Text(
                'Registrarse',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Register user
      toastification.show(
        context: context,
        title: const Text('Usuario registrado correctamente'),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
