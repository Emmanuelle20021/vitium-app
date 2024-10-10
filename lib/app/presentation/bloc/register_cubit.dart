import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/domain/models/register_model.dart';
import 'package:vitium/app/domain/models/user_model.dart';

class RegisterCubit extends Cubit<RegisterModel> {
  RegisterCubit()
      : super(
          RegisterModel(
            password: '',
            user: const UserModel(),
          ),
        );

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void setUser(UserModel user) {
    emit(state.copyWith(user: user));
  }

  void updateUser({
    id,
    role,
    name,
    image,
    email,
    phone,
    address,
    disabilities,
    companyCode,
  }) {
    final user = state.user.copyWith(
      id: id,
      role: role,
      name: name,
      image: image,
      email: email,
      phone: phone,
      address: address,
      disabilities: disabilities,
      companyCode: companyCode,
    );
    emit(state.copyWith(user: user));
  }

  void updateDisabilities(List<String> disabilities) {
    final user = state.user.copyWith(disabilities: disabilities);
    emit(state.copyWith(user: user));
  }

  void toggleDisability(String disability) {
    final disabilities = [...state.user.disabilities];
    if (disabilities.contains(disability)) {
      disabilities.remove(disability);
    } else {
      disabilities.add(disability);
    }
    updateDisabilities(disabilities);
  }

  void updateImage(File? file) {
    emit(state.copyWith(file: file));
  }

  void clearImage() {
    emit(state.clearImage());
  }

  void clearCubit() {
    emit(
      RegisterModel(
        password: '',
        user: const UserModel(),
      ),
    );
  }

  get user => state.user;
  get password => state.password;
  get file => state.file;
}
