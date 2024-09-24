import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/async_response.dart';

abstract class AccountRepository {
  Future<AsyncResponse<UserCredential>> createAccount(
    String email,
    String password,
  );
  Future<AsyncResponse<User>> login(
    String email,
    String password,
  );
  Future<AsyncResponse<bool>> logout();
  Future<AsyncResponse<bool>> deleteAccount();
  Future<AsyncResponse<bool>> sendEmailVerification();
  Future<AsyncResponse<bool>> checkEmailVerified();
  Future<AsyncResponse<bool>> sendPasswordResetEmail(String email);
  Future<AsyncResponse<User>> getCurrentUser();
  Future<AsyncResponse<String>> uploadProfilePicture(File photo);
  Future<AsyncResponse<bool>> deleteProfilePicture();
  Future<AsyncResponse<String>> getProfilePicture();
  Future<AsyncResponse<bool>> updateEmail(String email);
  Future<AsyncResponse<bool>> updatePassword(String password);
  Future<AsyncResponse<bool>> updatePhotoUrl(String photoUrl);
}
