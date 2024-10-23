import 'package:book/data/firebase_auth/firebase_auth_singleton.dart';
import 'package:book/models/app_user.dart';

class AppUserSingleton {
  static AppUserSingleton? _instance;
  AppUser? appUser;

  AppUserSingleton._internal();

  factory AppUserSingleton() {
    if (_instance == null) {
      _instance = AppUserSingleton._internal();
    }
    return _instance!;
  }

  Future<AppUser?> setUser() async {
    AppUser? result =
        await FirebaseAuthSingleton.instance.downloadCurrentUser();

    appUser = result;
    return result;
  }

  void clearUser() {
    appUser = null;
  }

  static AppUserSingleton get instance => AppUserSingleton();

  AppUser? get getAppUser => appUser;
}
