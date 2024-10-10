import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/domain/models/register_model.dart';
import '../../../bloc/register_cubit.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    this.radius = 50.0,
  });

  final double radius;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterModel>(
      listener: (context, state) {},
      builder: (context, registerState) {
        return LayoutBuilder(
          builder: (context, _) {
            debugPrint('register State: ${registerState.user.toString()}');
            if (registerState.user.image != null &&
                registerState.file == null &&
                registerState.user.image!.isNotEmpty) {
              return CircleAvatar(
                radius: radius,
                backgroundImage: Image.network(registerState.user.image!).image,
              );
            } else if (registerState.file != null) {
              return CircleAvatar(
                radius: radius,
                backgroundImage: Image.file(registerState.file!).image,
              );
            } else {
              return CircleAvatar(
                radius: radius,
                child: const Icon(Icons.camera_alt_outlined),
              );
            }
          },
        );
      },
    );
  }
}
