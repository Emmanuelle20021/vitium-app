import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  User? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register a new user
  Future<String> registerUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid ?? '';
    } catch (e) {
      // Handle any errors
      return e.toString();
    }
  }

  // Sign in an existing user
  Future<User?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // Handle any errors
      rethrow;
    }
  }

  // Check if the email is verified for the current user
  Future<bool> checkEmailVerified() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        return user.emailVerified;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out the current user
  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Handle any errors
    }
  }

  // Verificar el correo electrónico del usuario
  Future<bool> verifyEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        await UserService().signOutUser();
        user = null;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Eliminar un usuario
  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      // Manejar cualquier error
    }
  }

  // Cambiar la contraseña del usuario
  Future<void> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      // Handle any errors
      rethrow;
    }
  }

// Cambiar la foto de perfil del usuario
  Future<void> changeProfilePhoto(String photoURL) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePhotoURL(photoURL);
      }
    } catch (e) {
      // Handle any errors
      rethrow;
    }
  }

  // Subir una foto de perfil al Firebase Storage
  Future<String> uploadProfilePhoto(String uid, File photo) async {
    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_picture/$uid');
      TaskSnapshot snapshot = await storageRef.putFile(photo);
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      // Handle any errors
      rethrow;
    }
  }

  // Obtener la foto de perfil del usuario
  Future<String> getProfilePhoto() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return user.photoURL ?? '';
      }
      return '';
    } catch (e) {
      // Handle any errors
      rethrow;
    }
  }
}
