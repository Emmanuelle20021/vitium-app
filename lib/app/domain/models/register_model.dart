import 'dart:io';

import 'package:vitium/app/domain/models/user_model.dart';

class RegisterModel {
  String password;
  File? file;
  UserModel user;
  Exception? exception;

  RegisterModel({
    required this.password,
    required this.user,
    this.file,
    this.exception,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'user': user.toJson(),
      'exception': exception.toString(),
    };
  }

  RegisterModel copyWith({
    String? password,
    UserModel? user,
    File? file,
    Exception? exception,
    String? companyCode,
  }) {
    return RegisterModel(
      password: password ?? this.password,
      user: user ?? this.user,
      file: file ?? this.file,
      exception: exception ?? this.exception,
    );
  }

  RegisterModel clearImage() {
    return RegisterModel(
      password: password,
      user: user,
      file: null,
      exception: exception,
    );
  }

  RegisterModel clearException() {
    return RegisterModel(
      password: password,
      user: user,
      file: file,
      exception: null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterModel &&
        other.password == password &&
        other.user == user &&
        other.file == file &&
        other.exception == exception;
  }

  bool containsDisability(String disability) {
    return user.disabilities.contains(disability);
  }

  @override
  int get hashCode => password.hashCode ^ user.hashCode;

  bool get hasNoDisabilities => user.disabilities.isEmpty;

  @override
  String toString() =>
      'RegisterModel(password: $password, user: ${user.toString()})';

  bool isComplete() {
    return user.isComplete() && password.isNotEmpty;
  }

  bool notSame(Object other) {
    return !identical(this, other) ||
        other is! RegisterModel ||
        other.password != password ||
        other.user != user ||
        other.file != file ||
        other.exception != exception;
  }
}
