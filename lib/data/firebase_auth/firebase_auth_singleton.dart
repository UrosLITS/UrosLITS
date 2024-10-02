import 'package:book/core/constants.dart';
import 'package:book/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthSingleton {
  static FirebaseAuthSingleton? _instance;
  late FirebaseFirestore _db;
  late FirebaseAuth _auth;

  FirebaseAuthSingleton._internal() {
    _db = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  factory FirebaseAuthSingleton() {
    if (_instance == null) {
      _instance = FirebaseAuthSingleton._internal();
    }
    return _instance!;
  }

  FirebaseFirestore get db => _db;

  static FirebaseAuthSingleton get instance => FirebaseAuthSingleton();

  FirebaseAuth get auth => _auth;

  Future<void> login(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
  }

  Future<String?> checkUserLogin() async {
    if (_auth.currentUser?.uid != null) {
      return _auth.currentUser!.uid;
    } else {
      return null;
    }
  }

  Future<AppUser?> downloadCurrentUser() async {
    final result = await checkUserLogin()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    if (result != null) {
      final userRef = _db.collection(usersCollection).doc(result);
      final snapshotRef = await userRef
          .get()
          .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
        throw Exception(timeoutErrorMessage);
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

  Future<void> registration(AppUser user) async {
    String? uID;

    await _auth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    final User? checkUser = _auth.currentUser;
    if (checkUser != null) {
      uID = checkUser.uid;
      await FirebaseAuthSingleton.instance.auth.signOut();
    }
    final userRef = _db.collection(usersCollection).doc(uID);
    await userRef.set(user.toJson()).timeout(Duration(seconds: timeoutDuration),
        onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
  }
}
