import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imess/models/user_model.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  SelectContactRepository({required this.firestore, required this.auth});

  Future<List<Map<String, String>>> getUser() async {
    List<Map<String, String>> results = [];
    await firestore
        .collection("users")
        .where("phoneNumber", isNotEqualTo: auth.currentUser!.phoneNumber)
        .get()
        .then((value) {
      for (var document in value.docs) {
        var userData = UserModel.fromSnap(document);
        results.add({
          "phoneNumber": userData.phoneNumber,
          "username": userData.username,
          "uid": userData.uid,
          "photoUrl": userData.photoUrl
        });
      }
    });
    return results;
  }
}
