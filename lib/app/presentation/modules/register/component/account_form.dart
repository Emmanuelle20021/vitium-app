import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/presentation/global/components/inputs/underline_input.dart';

import '../../../../data/utils/constants/constants.dart';
import '../../../../domain/models/register_model.dart';
import '../../../bloc/register_cubit.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterModel>(
      bloc: context.watch<RegisterCubit>(),
      builder: (context, state) {
        initializeControllers(context, state);
        return Form(
          key: widget.formKey,
          child: Column(
            children: [
              UnderlineInput(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.person_outline_outlined,
                hintText: 'Correo electrónico',
                label: Text(
                  'Correo electrónico',
                  style: kInputLabelStyle,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su email';
                  }
                  return null;
                },
                onChanged: (value) =>
                    context.read<RegisterCubit>().updateUser(email: value),
              ),
              UnderlineInput(
                controller: passwordController,
                obscureText: true,
                icon: Icons.lock_outline,
                hintText: 'Contraseña',
                label: Text(
                  'Contraseña',
                  style: kInputLabelStyle,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
                onChanged: (value) =>
                    context.read<RegisterCubit>().updatePassword(value),
              ),
              UnderlineInput(
                icon: Icons.lock_outline,
                label: Text(
                  'Confirmar contraseña',
                  style: kInputLabelStyle,
                ),
                hintText: 'Confirmar contraseña',
                controller: confirmPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value != passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              Text(
                state.exception.toString(),
              ),
            ],
          ),
        );
      },
      listener: (BuildContext context, RegisterModel state) {},
    );
  }

  void initializeControllers(BuildContext context, RegisterModel state) {
    emailController.text = state.user.email ?? '';
    emailController.addListener(() {
      context.read<RegisterCubit>().updateUser(email: emailController.text);
    });
    passwordController.text = state.password;
    passwordController.addListener(() {
      context.read<RegisterCubit>().updatePassword(passwordController.text);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
