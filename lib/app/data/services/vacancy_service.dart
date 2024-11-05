import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vitium/app/domain/models/async_response.dart';
import 'package:vitium/app/domain/models/vacancy_model.dart';

class VacancyService {
  VacancyService._();

  static const vacancysPath = 'vacancy';
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Future<AsyncResponse<List<Vacancy>>> getVacancys() async {
    try {
      List<Vacancy> vacancys = [];
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection(vacancysPath).get();
      if (querySnapshot.docs.isEmpty) {
        return AsyncResponse(data: []);
      }
      for (final queryDocumentSnapshot in querySnapshot.docs) {
        vacancys.add(
          Vacancy.fromJson(
            queryDocumentSnapshot.id,
            queryDocumentSnapshot.data(),
          ),
        );
        debugPrint('Vacantes recuperadas: ${vacancys.length}, $vacancys');
      }
      return AsyncResponse(data: vacancys);
    } catch (e) {
      debugPrint('Error al recuperar las vacantes: $e');
      return AsyncResponse(
        exception: Exception(
          'Error al recuperar las vacantes',
        ),
      );
    }
  }

  static Future<AsyncResponse<List<Vacancy>>> getMyVacancies(String id) async {
    try {
      List<Vacancy> vacancys = [];
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection(vacancysPath)
              .where('owner', isEqualTo: id)
              .get();
      if (querySnapshot.docs.isEmpty) {
        return AsyncResponse(data: []);
      }
      for (final queryDocumentSnapshot in querySnapshot.docs) {
        vacancys.add(
          Vacancy.fromJson(
            queryDocumentSnapshot.id,
            queryDocumentSnapshot.data(),
          ),
        );
        debugPrint('Vacantes recuperadas: ${vacancys.length}');
      }
      return AsyncResponse(data: vacancys);
    } catch (e) {
      debugPrint('Error al recuperar las vacantes: $e');
      return AsyncResponse(
        exception: Exception(
          'Error al recuperar las vacantes',
        ),
      );
    }
  }

  static Future<AsyncResponse<bool>> createVacancy(Vacancy vacancy) async {
    try {
      await _firebaseFirestore.collection(vacancysPath).add(vacancy.toJson());
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<List<Vacancy>>> getMyPostulantVacancies(
      String id) async {
    try {
      List<Vacancy> vacancys = [];
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection(vacancysPath).where(
        'postulants',
        arrayContainsAny: [
          {'id': id, 'status': 'Pendiente'},
          {'id': id, 'status': 'Rechazado'},
          {'id': id, 'status': 'Aceptado'},
        ],
      ).get();
      if (querySnapshot.docs.isEmpty) {
        return AsyncResponse(data: []);
      }
      for (final queryDocumentSnapshot in querySnapshot.docs) {
        vacancys.add(
          Vacancy.fromJson(
            queryDocumentSnapshot.id,
            queryDocumentSnapshot.data(),
          ),
        );
        debugPrint('Vacantes recuperadas: ${vacancys.length}');
      }
      return AsyncResponse(data: vacancys);
    } catch (e) {
      debugPrint('Error al recuperar las vacantes: $e');
      return AsyncResponse(
        exception: Exception(
          'Error al recuperar las vacantes',
        ),
      );
    }
  }

  static Future<AsyncResponse<bool>> updateVacancy(Vacancy vacancy) async {
    try {
      final vacancyRefs =
          _firebaseFirestore.collection(vacancysPath).doc(vacancy.id);
      await vacancyRefs.update(vacancy.toJson());
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<bool>> deleteVacancy(String id) async {
    try {
      final vacancyRefs = _firebaseFirestore.collection(vacancysPath).doc(id);
      await vacancyRefs.delete();
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<Vacancy>> getVacancy(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firebaseFirestore.collection(vacancysPath).doc(id).get();
      final Vacancy vacancy =
          Vacancy.fromJson(documentSnapshot.id, documentSnapshot.data()!);
      return AsyncResponse(data: vacancy);
    } catch (e) {
      return AsyncResponse(
        exception: Exception(
          'Error al recuperar la vacante',
        ),
      );
    }
  }

  static Future<AsyncResponse<bool>> applyVacancy(
      {required String id, required String postulant}) async {
    try {
      final DocumentReference<Map<String, dynamic>> vacancyRefs =
          _firebaseFirestore.collection(vacancysPath).doc(id);
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await vacancyRefs.get();
      final List<dynamic> postulants = documentSnapshot.data()!['postulants'];
      postulants.add({'id': postulant, 'status': 'Pendiente'});
      await vacancyRefs.update({'postulants': postulants});
      return AsyncResponse(data: true);
    } catch (e) {
      debugPrint('Error al aplicar a la vacante: $e');
      throw Exception('Hubo un error al postularte. Intenta de nuevo.');
    }
  }

  static Future<AsyncResponse<bool>> cancelPostulation(
      String id, String postulant) async {
    try {
      final DocumentReference<Map<String, dynamic>> vacancyRefs =
          _firebaseFirestore.collection(vacancysPath).doc(id);
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await vacancyRefs.get();
      List<dynamic> postulants = documentSnapshot.data()!['postulants'];
      postulants =
          postulants.where((element) => element['id'] != postulant).toList();
      await vacancyRefs.update({'postulants': postulants});
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<bool>> closeVacancy(String id) async {
    try {
      final DocumentReference<Map<String, dynamic>> vacancyRefs =
          _firebaseFirestore.collection(vacancysPath).doc(id);
      await vacancyRefs.update({'status': 'closed'});
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<bool>> openVacancy(String id) async {
    try {
      final DocumentReference<Map<String, dynamic>> vacancyRefs =
          _firebaseFirestore.collection(vacancysPath).doc(id);
      await vacancyRefs.update({'status': 'open'});
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<bool>> finishVacancy(String id) async {
    try {
      final DocumentReference<Map<String, dynamic>> vacancyRefs =
          _firebaseFirestore.collection(vacancysPath).doc(id);
      await vacancyRefs.update({'status': 'finished'});
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<bool>> startVacancy(String id) async {
    try {
      final DocumentReference<Map<String, dynamic>> vacancyRefs =
          _firebaseFirestore.collection(vacancysPath).doc(id);
      await vacancyRefs.update({'status': 'started'});
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<bool>> pauseVacancy(String id) async {
    try {
      final DocumentReference<Map<String, dynamic>> vacancyRefs =
          _firebaseFirestore.collection(vacancysPath).doc(id);
      await vacancyRefs.update({'status': 'paused'});
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<bool>> updatePostulationOfPostulant({
    required String idVacancy,
    required String idPostulant,
    required String status,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> vacancyRefs =
          _firebaseFirestore.collection(vacancysPath).doc(idVacancy);
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await vacancyRefs.get();
      final List<dynamic> postulants = documentSnapshot.data()!['postulants'];
      final index =
          postulants.indexWhere((element) => element['id'] == idPostulant);
      postulants[index]['status'] = status;
      await vacancyRefs.update({'postulants': postulants});
      return AsyncResponse(data: true);
    } catch (e) {
      return AsyncResponse(exception: e as Exception);
    }
  }

  static Future<AsyncResponse<List<Map<String, dynamic>>>> getPostulants(
    vacancyId,
  ) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firebaseFirestore
              .collection(vacancysPath)
              .doc(vacancyId)
              .get();
      final List<Map<String, dynamic>> postulants =
          List<Map<String, dynamic>>.from(
              documentSnapshot.data()!['postulants']);
      return AsyncResponse(data: postulants);
    } catch (e) {
      return AsyncResponse(
        exception: Exception(
          'Error al recuperar los postulantes',
        ),
      );
    }
  }
}
