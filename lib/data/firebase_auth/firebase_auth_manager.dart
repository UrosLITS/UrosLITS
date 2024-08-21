import 'package:book/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthManager {
  static final db = FirebaseFirestore.instance;

  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> login(String email, String password) async {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception("Cant reach server");
    });
  }

  static Future<String?> checkUserLogin() async {
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
        final user = AppUser.fromJson(snapshotRef.data()!);
        return user;
      } else {
        return null;
      }
    }
    return null;
  }

  static Future<void> registration(AppUser user) async {
    String? uID;

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
    final userRef = db.collection("users").doc(uID);
    await userRef.set(user.toJson()).timeout(Duration(seconds: 3),
        onTimeout: () {
      throw Exception("Cant reach server");
    });
  }
}
