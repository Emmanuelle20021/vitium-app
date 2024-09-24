import 'dart:io';

import 'package:vitium/app/domain/models/user_model.dart';

class RegisterModel {
  String password;
  File? file;
  User user;
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

  RegisterModel copyWith(
      {String? password, User? user, File? file, Exception? exception}) {
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

  @override
  int get hashCode => password.hashCode ^ user.hashCode;

  @override
  String toString() => 'RegisterModel(password: $password, user: $user)';

  bool isComplete() {
    return user.isComplete() && password.isNotEmpty;
  }

  bool notSame(Object other) {
    return !identical(this, other) ||
        other is! RegisterModel ||
        other.password != password ||
        other.user != user;
  }
}
