import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:mobie_ticket_app/models/chat.dart';
import 'package:mobie_ticket_app/models/user_profile.dart';
import 'package:mobie_ticket_app/services/auth_service.dart';
import 'package:mobie_ticket_app/utils.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference? _usersCollection;
  late CollectionReference? _chatsCollection;

  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  DatabaseService() {
    _setupCollectionReferences();
    _authService = _getIt.get<AuthService>();
  }

  // withConverter sử dụng Map

  void _setupCollectionReferences() {
    _usersCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot
                  .data()!), // khác với model ở dưới vì cách định nghĩa fromMap giống với from json của video
              toFirestore: (userProfile, _) => userProfile.toMap(),
            );

    _chatsCollection =
        _firebaseFirestore.collection('chats').withConverter<Chat>(
              fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
              toFirestore: (chat, _) => chat.toJson(),
            );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }

  // SD stream vì sẽ tự update UI khi db thay đổi => QuerySnapshot
  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _usersCollection!
        .where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _chatsCollection?.doc().get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID);
    final chat = Chat(
      id: chatID,
      messages: [],
      participants: [uid1, uid2],
    );
    await docRef.set(chat);
  }
}
