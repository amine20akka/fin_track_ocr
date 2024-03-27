import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track_ocr/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String firstName, String lastName) async {
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return UserData(
        uid: uid,
        firstName: data!['firstName'],
        lastName: data['lastName']
      );
  }

  // get user document stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
