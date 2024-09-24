import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../global/components/visual_details/aplication_name_tag.dart';
import '../../../global/components/visual_details/header_with_logo.dart';
import '../../../routes/routes.dart';
import '../component/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(kPagingTouchSlop),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const AplicationNameTag(),
            const HeaderWithLogo(
              title: 'Únete a nosotros',
              subtitle: 'Crea tu cuenta para empezar con vitium',
            ),
            const RegisterUserForm(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿Ya tienes una cuenta? ',
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.login);
                  },
                  child: const Text(
                    'Inicia Sesión',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
