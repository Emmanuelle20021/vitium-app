import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../domain/models/register_model.dart';
import '../../../bloc/register_cubit.dart';
import '../../../global/components/visual_details/profile_image.dart';

class PhotoForm extends StatelessWidget {
  const PhotoForm({super.key});

  Future<File?> _selectProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    return File(pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: BlocBuilder<RegisterCubit, RegisterModel>(
        builder: (context, registerState) {
          return Center(
            child: GestureDetector(
              onTap: () async {
                final file = await _selectProfileImage();
                if (file != null && context.mounted) {
                  context.read<RegisterCubit>().updateImage(file);
                }
              },
              onDoubleTap: () => context.read<RegisterCubit>().clearImage(),
              child: const ProfileImage(),
            ),
          );
        },
      ),
    );
  }
}
