import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final Map<String, Object>? data = snapshot.data() as Map<String, Object>?;
    return UserModel(
      uid: snapshot.id,
      email: data?['email'] as String?,
      displayName: data?['displayName'] as String?,
      photoUrl: data?['photoUrl'] as String?,
    );
  }
}
