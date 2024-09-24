import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitium/app/domain/models/postulant_model.dart';

const postulantsCollectionName = 'postulants';

class PostulantService {
  final postulantsCollection = FirebaseFirestore.instance
      .collection(postulantsCollectionName)
      .withConverter(
        fromFirestore: (snapshot, _) =>
            Postulant.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (postulant, _) => postulant.toJson(),
      );
  final reference =
      FirebaseFirestore.instance.collection(postulantsCollectionName);

  // Create a new postulant
  Future<void> createPostulant(Postulant postulant) async {
    await reference.doc(postulant.id).set(postulant.toJson());
  }

  // Get all postulants
  Future<List<Postulant>> getAllPostulants() async {
    var result = await postulantsCollection.get().then((value) => value);
    List<Postulant> postulants = [];
    for (var doc in result.docs) {
      postulants.add(doc.data());
    }
    return Future.value(postulants);
  }

  // Get a specific postulant by ID
  Future<Postulant> getPostulantById(String id) async {
    DocumentSnapshot snapshot = await postulantsCollection.doc(id).get();
    if (snapshot.exists) {
      return Postulant.fromJson(
          snapshot.id, snapshot.data() as Map<String, dynamic>);
    } else {
      return Postulant.fromJson('', {});
    }
  }

  // Update a postulant
  Future<void> updatePostulant(Postulant postulant) async {
    await postulantsCollection.doc(postulant.id).update(postulant.toJson());
  }

  // Delete a postulant
  Future<void> deletePostulant(String id) async {
    await postulantsCollection.doc(id).delete();
  }

  // Update image of postulant
  Future<void> updateProfileImage(String postulantId, String imageUrl) async {
    var reference = FirebaseFirestore.instance
        .collection(postulantsCollectionName)
        .doc(postulantId);
    return reference.update({'image': imageUrl});
  }
}
