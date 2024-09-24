import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitium/app/domain/models/postulant_model.dart';
import 'package:vitium/app/data/services/postulant_service.dart';

class PostulantCreateProfileScreen extends StatefulWidget {
  const PostulantCreateProfileScreen({super.key});

  @override
  State<PostulantCreateProfileScreen> createState() =>
      _PostulantCreateProfileScreenState();
}

class _PostulantCreateProfileScreenState
    extends State<PostulantCreateProfileScreen> {
  final postulantService = PostulantService();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
                controller: firstNameController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
                controller: lastNameController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
                controller: addressController,
              ),
              ElevatedButton(
                onPressed: () => saveProfile(
                  firstNameController.text,
                  lastNameController.text,
                  phoneNumberController.text,
                  addressController.text,
                ),
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveProfile(
    String firstName,
    String lastName,
    String phoneNumber,
    String address,
  ) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('User not logged in');
      return;
    }
    final newPostulant = Postulant(
      id: user.uid,
      name: '$firstName $lastName',
      image: '',
      email: user.email ?? '',
      phone: phoneNumber,
      address: address,
      disabilities: ['Motriz', 'Fisica'],
    );
    postulantService.createPostulant(newPostulant);
    debugPrint('Profile saved');
  }
}
