import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vitium/app/domain/models/async_response.dart';
import 'package:vitium/app/domain/repository/account_repository.dart';

class FirebaseAuthRepositoryImplementation implements AccountRepository {
  FirebaseAuthRepositoryImplementation({
    required FirebaseAuth firebaseAuth,
  }) : _auth = firebaseAuth;

  final FirebaseAuth _auth;

  @override
  Future<AsyncResponse<bool>> checkEmailVerified() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        user.reload();
        return AsyncResponse(data: user.emailVerified);
      }
      return AsyncResponse(data: false);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<UserCredential>> createAccount(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return AsyncResponse(
        data: userCredential,
      );
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<bool>> deleteAccount() async {
    try {
      await _auth.currentUser!.delete();
      return AsyncResponse(data: true);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<bool>> deleteProfilePicture() async {
    try {
      await _auth.currentUser!.updatePhotoURL(null);
      return AsyncResponse(data: true);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<User>> getCurrentUser() async {
    try {
      User user = _auth.currentUser!;
      return AsyncResponse(data: user);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<String>> getProfilePicture() async {
    try {
      String? photoUrl = _auth.currentUser!.photoURL;
      return AsyncResponse(data: photoUrl);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<User>> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _auth.currentUser!.reload();
      return AsyncResponse(data: userCredential.user);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<bool>> logout() async {
    try {
      await _auth.signOut();
      return AsyncResponse(data: true);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<bool>> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      return AsyncResponse(data: true);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<bool>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AsyncResponse(data: true);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<bool>> updateEmail(String address) async {
    try {
      await _auth.currentUser!.verifyBeforeUpdateEmail(address);
      return AsyncResponse(data: true);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<bool>> updatePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
      return AsyncResponse(data: true);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<bool>> updatePhotoUrl(String photoUrl) async {
    try {
      await _auth.currentUser!.updatePhotoURL(photoUrl);
      return AsyncResponse(data: true);
    } on FirebaseAuthException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<String>> uploadProfilePicture(File photo) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child(
            'profile_picture/${_auth.currentUser!.uid}',
          );
      TaskSnapshot snapshot = await storageRef.putFile(photo);
      String downloadURL = await snapshot.ref.getDownloadURL();
      return AsyncResponse(data: downloadURL);
    } on FirebaseException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<String>> uploadCv(File cv) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child(
            'cv/${_auth.currentUser!.uid}',
          );
      TaskSnapshot snapshot = await storageRef.putFile(cv);
      String downloadURL = await snapshot.ref.getDownloadURL();
      return AsyncResponse(data: downloadURL);
    } on FirebaseException catch (exception) {
      return AsyncResponse(
        exception: exception,
      );
    }
  }

  @override
  Future<AsyncResponse<String>> getRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      final firebaseInstance = FirebaseFirestore.instance;
      final userRef = firebaseInstance.collection('postulants').doc(user.uid);
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        return AsyncResponse(data: 'postulant');
      }
      final recruiterRef =
          firebaseInstance.collection('recruiters').doc(user.uid);
      final recruiterDoc = await recruiterRef.get();
      if (recruiterDoc.exists) {
        return AsyncResponse(data: 'recruiter');
      }
      return AsyncResponse(data: null);
    } else {
      return AsyncResponse(data: null);
    }
  }
}
