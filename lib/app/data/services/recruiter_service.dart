import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitium/app/domain/models/recruiter_model.dart';

const recruitersCollectionName = 'recruiters';

class RecruiterService {
  final recruitersCollection = FirebaseFirestore.instance
      .collection(recruitersCollectionName)
      .withConverter(
        fromFirestore: (snapshot, _) =>
            Recruiter.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (recruiter, _) => recruiter.toJson(),
      );
  final reference =
      FirebaseFirestore.instance.collection(recruitersCollectionName);

  // Create a new recruiter
  Future<void> createRecruiter(Recruiter recruiter) async {
    await reference.add(recruiter.toJson());
  }

  // Get all recruiters
  Future<List<Recruiter>> getAllRecruiters() async {
    QuerySnapshot snapshot = await recruitersCollection.get();
    List<Recruiter> recruiters = [];
    for (var doc in snapshot.docs) {
      recruiters
          .add(Recruiter.fromJson('', doc.data() as Map<String, dynamic>));
    }
    return recruiters;
  }

  // Get a specific recruiter by ID
  Future<Recruiter> getRecruiterById(String id) async {
    DocumentSnapshot snapshot = await recruitersCollection.doc(id).get();
    if (snapshot.exists) {
      return Recruiter.fromJson(
          snapshot.id, snapshot.data() as Map<String, dynamic>);
    } else {
      return Recruiter.fromJson('', {});
    }
  }

  // Update a recruiter
  Future<void> updateRecruiter(Recruiter recruiter) async {
    await recruitersCollection.doc(recruiter.id).update(recruiter.toJson());
  }

  // Delete a recruiter
  Future<void> deleteRecruiter(String id) async {
    await recruitersCollection.doc(id).delete();
  }
}
