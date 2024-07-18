import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String name, String bloodType) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'bloodType': bloodType,
    });
  }

  // Get user data
  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }
}
