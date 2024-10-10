import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitium/app/domain/models/async_response.dart';

import '../../domain/models/user_model.dart';

class UserService {
  UserService._();

  static const String _userCollectionName = 'users';
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Future<AsyncResponse<bool>> createUser(UserModel user) async {
    try {
      await _firebaseFirestore
          .collection(_userCollectionName)
          .doc(user.id)
          .set(user.toJson());
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<UserModel>> getUser(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firebaseFirestore
              .collection(_userCollectionName)
              .doc(id)
              .get();
      final UserModel user = UserModel.fromJson(id, documentSnapshot.data()!);
      return AsyncResponse(data: user);
    } catch (e) {
      return AsyncResponse(
        exception: Exception(
          'Error al recuperar el usuario',
        ),
      );
    }
  }

  static Future<AsyncResponse<bool>> updateUser(UserModel user) async {
    try {
      await _firebaseFirestore
          .collection(_userCollectionName)
          .doc(user.id)
          .update(user.toJson());
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<List<UserModel>>> getUsers(
      List<Map<String, dynamic>> postulantion) async {
    try {
      final List<UserModel> users = <UserModel>[];
      for (final postulant in postulantion) {
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await _firebaseFirestore
                .collection(_userCollectionName)
                .doc(postulant['id'])
                .get();
        final UserModel user =
            UserModel.fromJson(postulant['id'], documentSnapshot.data()!);
        users.add(user);
      }
      return AsyncResponse(data: users);
    } catch (e) {
      return AsyncResponse(
        exception: Exception(
          'Error al recuperar el usuario',
        ),
      );
    }
  }

}
