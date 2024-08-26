import 'package:book/data/firebase_auth/firebase_auth_singleton.dart';
import 'package:book/models/app_user.dart';

class AppUserSingleton {
  static AppUserSingleton? _instance;
  AppUser? _appUser;

  AppUserSingleton._internal() {
    _appUser = _appUser;
  }

  factory AppUserSingleton() {
    if (_instance == null) {
      _instance = AppUserSingleton._internal();
    }
    return _instance!;
  }

  Future<AppUser?> setUser() async {
    AppUser? result =
        await FirebaseAuthSingleton.instance.downloadCurrentUser();

    _appUser = result;
    return result;
  }

  void clearUser() {
    _appUser = null;
  }

  static FirebaseAuthSingleton get instance => FirebaseAuthSingleton();

  AppUser? get appUser => _appUser;
}
