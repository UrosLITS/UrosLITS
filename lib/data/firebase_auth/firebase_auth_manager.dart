import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/app_user.dart';

class FirebaseAuthManager {
  static final db = FirebaseFirestore.instance;

  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<String?> login(String email, String password) async {
    String? errorMessage;

    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(Duration(seconds: 3), onTimeout: () {
        throw Exception("Cant reach server");
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        errorMessage = "User  is  not found";
      } else if (e.code == "wrong-password") {
        errorMessage = "Incorrect password";
      } else {
        return errorMessage = e.message;
      }
    }
    return errorMessage;
  }

  static Future<String?> checkUserLogin() async {
    await auth.currentUser?.uid;

    if (auth.currentUser?.uid != null) {
      return auth.currentUser!.uid;
    } else {
      return null;
    }
  }

  static Future<AppUser?> downloadCurrentUser() async {
    final result =
        await checkUserLogin().timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception("Cant reach server");
    });

    if (result != null) {
      final userRef = db.collection("users").doc(result);
      final snapshotRef =
          await userRef.get().timeout(Duration(seconds: 3), onTimeout: () {
        throw Exception("Cant reach server");
      });

      if (snapshotRef.data() != null) {
        AppUser users = AppUser.fromJson(snapshotRef.data()!);
        return users;
      } else {
        return null;
      }
    }
    return null;
  }

  static Future<String?> registration(AppUser user) async {
    String? uID;
    String? errorMessage;

    try {
      await auth
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password)
          .timeout(Duration(seconds: 3), onTimeout: () {
        throw Exception("Cant reach server");
      });
      final User? checkUser = auth.currentUser;
      if (checkUser != null) {
        uID = checkUser.uid;
      }
      final userREF = db.collection("users").doc(uID);
      await userREF.set(user.toJson()).timeout(Duration(seconds: 3),
          onTimeout: () {
        throw Exception("Cant reach server");
      });
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        errorMessage = e.message;
      }
    }
    return errorMessage;
  }
}
