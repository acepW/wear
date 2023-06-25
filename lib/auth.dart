import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wears/model/user_model.dart' as model;

import 'const/firebase_const.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final User? user = authInstance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.UserModel> getUserDetails() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('akun').doc(user!.uid).get();

    return model.UserModel.fromSnap(documentSnapshot);
  }

  // Signing Up User

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Maaf tidak ada yang boleh kosong";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
