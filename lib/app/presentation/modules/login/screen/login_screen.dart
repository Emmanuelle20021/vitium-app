import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../global/components/visual_details/aplication_name_tag.dart';
import '../../../global/components/visual_details/header_with_logo.dart';
import '../../../routes/routes.dart';
import '../component/login_user_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            bottom: -50,
            child: Container(
              width: width,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.elliptical(
                    width,
                    50,
                  ),
                  right: Radius.elliptical(
                    width,
                    50,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kPagingTouchSlop),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const AplicationNameTag(),
                const HeaderWithLogo(
                  title: '¡Bienvenido de vuelta!',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: const FormLoginUser(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes una cuenta? ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Routes.register);
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
