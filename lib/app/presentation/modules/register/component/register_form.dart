import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/data/services/user_service.dart';
import 'package:vitium/app/data/utils/validators.dart';
import 'package:vitium/app/presentation/bloc/exception_handler_cubit.dart';
import 'package:vitium/app/presentation/bloc/register_cubit.dart';
import 'package:vitium/app/presentation/global/components/buttons/rectangle_button.dart';

import '../../../../data/utils/injector.dart';
import '../../../global/components/inputs/underline_input.dart';
import '../../../routes/routes.dart';

class RegisterUserForm extends StatefulWidget {
  const RegisterUserForm({super.key});

  @override
  State<RegisterUserForm> createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  bool isRecruiter = false;
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
            CheckboxListTile(
              title: const Text('Soy reclutador'),
              controlAffinity: ListTileControlAffinity.platform,
              value: isRecruiter,
              onChanged: (value) {
                setState(() {
                  isRecruiter = value!;
                });
              },
              checkboxSemanticLabel: 'Soy reclutador',
              activeColor: Colors.blue,
              secondary: const Icon(
                Icons.business_center_outlined,
              ),
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

  void _register() async {
    if (_formKey.currentState!.validate() && mounted) {
      // Register user
      final auth = Injector.of(context).accountRepository;
      final authResponse = await auth.createAccount(
        _emailController.text,
        _passwordController.text,
      );
      if (authResponse.data != null && mounted) {
        final registerCubit = context.read<RegisterCubit>();
        registerCubit.updateUser(
          email: _emailController.text,
        );
        registerCubit.updatePassword(_passwordController.text);
        registerCubit.updateUser(
          role: isRecruiter ? 'recruiter' : 'postulant',
          id: authResponse.data?.user?.uid,
        );
        final userCreationResponser = await UserService.createUser(
          registerCubit.state.user,
        );
        if (userCreationResponser.data != null && mounted) {
          Navigator.pushReplacementNamed(
            context,
            Routes.login,
          );
        } else if (userCreationResponser.exception != null && mounted) {
          context.read<ExceptionHandlerCubit>().handleException(
                userCreationResponser.exception!,
                'Error al crear usuario',
              );
        }
      } else if (authResponse.exception != null && mounted) {
        context.read<ExceptionHandlerCubit>().handleException(
              authResponse.exception!,
              'Error al crear usuario',
            );
      }
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
