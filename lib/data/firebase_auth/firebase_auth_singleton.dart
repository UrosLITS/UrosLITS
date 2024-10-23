import 'dart:io';

import 'package:book/core/constants.dart';
import 'package:book/models/app_user.dart';
import 'package:book/utils/exception_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      throw ServerConnectionException();
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
      throw ServerConnectionException();
    });

    if (result != null) {
      final userRef = _db.collection(usersCollection).doc(result);
      final snapshotRef = await userRef
          .get()
          .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
        throw ServerConnectionException();
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
      throw ServerConnectionException();
    });
    final User? checkUser = _auth.currentUser;
    if (checkUser != null) {
      uID = checkUser.uid;
    }
    final userRef = _db.collection(usersCollection).doc(uID);
    await userRef.set(user.toJson()).timeout(Duration(seconds: timeoutDuration),
        onTimeout: () {
      throw ServerConnectionException();
    });
    await _auth.signOut();
  }

  Future<UserCredential?> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      loginTracking: LoginTracking.enabled,
    );

    if (loginResult.accessToken == null) {
      return null;
    }

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    return await _auth.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential?> signInWithGoogle() async {
    late GoogleSignIn _googleSignIn;

    if (Platform.isIOS) {
      _googleSignIn = await GoogleSignIn(clientId: clientID, scopes: [email]);
    } else if (Platform.isAndroid) {
      _googleSignIn = await GoogleSignIn(scopes: [email]);
    }

    await _googleSignIn.signOut().timeout(Duration(seconds: timeoutDuration),
        onTimeout: () {
      throw ServerConnectionException();
    });

    final GoogleSignInAccount? gUser = await _googleSignIn
        .signIn()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw ServerConnectionException();
    });

    if (gUser == null) {
      return null;
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);

    if (credential.providerId == google) {
      await _auth.currentUser?.unlink(google);
    }

    await _auth.currentUser?.linkWithCredential(credential);

    return result;
  }

  Future<void> addUserToDatabase(AppUser appUser) async {
    String? uID;
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      uID = currentUser.uid;

      final credential = EmailAuthProvider.credential(
          email: appUser.email, password: appUser.password);
      await _auth.currentUser?.linkWithCredential(credential);
    }
    final userRef = _db.collection(usersCollection).doc(uID);
    await userRef
        .set(appUser.toJson())
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw ServerConnectionException();
    });
    await _auth.signOut().timeout(Duration(seconds: timeoutDuration),
        onTimeout: () {
      throw ServerConnectionException();
    });
  }

  Future<void> checkEmailVerified() async {
    User? user = _auth.currentUser;

    if (user!.emailVerified) {
      print(emailVerified);
    } else {
      await _auth.currentUser?.sendEmailVerification();
    }
  }
}
