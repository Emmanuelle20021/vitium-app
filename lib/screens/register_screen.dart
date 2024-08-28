import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitium/services/auth/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:vitium/services/postulant_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? profileImage;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String? actualProfileImage = FirebaseAuth.instance.currentUser?.photoURL!;

  void _selectProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (actualProfileImage != null) ...[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(actualProfileImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16.0),
                Text(currentUser!.email ?? ''),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  controller: emailController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  controller: passwordController,
                ),
                ElevatedButton(
                  onPressed: () =>
                      register(emailController.text, passwordController.text),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _selectProfileImage,
                  child: const Text('Select Profile Image'),
                ),
                if (profileImage != null) ...[
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Image.file(
                      profileImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _uploadProfileImage,
                    child: const Text('Aceptar'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _uploadProfileImage() async {
    if (profileImage != null) {
      final url = await UserService().uploadProfilePhoto(
        currentUser!.uid,
        profileImage!,
      );
      UserService().changeProfilePhoto(url).then(
            (value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile image uploaded'),
                ),
              ),
            },
          );
      PostulantService().updateProfileImage(currentUser!.uid, url);
    }
  }

  void register(String email, String password) async {
    String response = await UserService().registerUser(
      email,
      password,
    );
    debugPrint(response);
  }
}
