import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;

  final double heartRate;

  final Timestamp createdAt;

  const UserModel({
    required this.createdAt,
    required this.uid,
    required this.email,
    required this.heartRate,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      createdAt: snapshot["createdAt"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      heartRate: snapshot["heartRate"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "heartRate": heartRate,
        "createdAt": Timestamp.now()
      };
}
