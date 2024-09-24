import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/domain/models/register_model.dart';
import 'package:vitium/app/domain/models/user_model.dart';

class RegisterCubit extends Cubit<RegisterModel> {
  RegisterCubit()
      : super(
          RegisterModel(
            password: '',
            user: const User(),
          ),
        );

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void updateUser({name, image, email, phone, address}) {
    final user = state.user.copyWith(
      name: name,
      image: image,
      email: email,
      phone: phone,
      address: address,
    );
    emit(state.copyWith(user: user));
  }

  void updateImage(File? file) {
    emit(state.copyWith(file: file));
  }

  void clearImage() {
    emit(state.clearImage());
  }

  get user => state.user;
  get password => state.password;
  get file => state.file;
}
