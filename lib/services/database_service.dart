import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobie_ticket_app/models/user_profile.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference _usersCollection;
  DatabaseService() {
    _setupCollectionReferences();
  }

  // withConverter sử dụng Map

  void _setupCollectionReferences() {
    _usersCollection = _firebaseFirestore
        .collection('users')
        .withConverter<UserProfile>(
          fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
          toFirestore: (userProfile, _) => userProfile.toMap(),
        );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection.doc(userProfile.uid).set(userProfile);
  }
}
