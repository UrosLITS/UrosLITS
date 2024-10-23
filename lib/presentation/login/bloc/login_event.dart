import 'package:book/models/app_user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class LoginEvent extends Equatable {}

class Login extends LoginEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUp extends LoginEvent {
  final AppUser appUser;

  SignUp({required this.appUser});

  @override
  List<Object?> get props => [appUser];
}

class GoogleSignIn extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class CreateUserWithGoogleAcc extends LoginEvent {
  CreateUserWithGoogleAcc({required this.userCredential});

  final UserCredential userCredential;

  @override
  List<Object?> get props => [userCredential];
}

class SignUpWithProvider extends LoginEvent {
  SignUpWithProvider({required this.appUser});

  final AppUser appUser;

  @override
  List<Object?> get props => [appUser];
}

class FacebookSignIn extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class SignUpWithFacebook extends LoginEvent {
  SignUpWithFacebook({
    required this.appUser,
    required this.userCredential,
  });

  final AppUser appUser;
  final UserCredential userCredential;

  @override
  List<Object?> get props => [];
}

class CreateUserWithFacebookAcc extends LoginEvent {
  CreateUserWithFacebookAcc({required this.userCredential});

  final UserCredential userCredential;

  @override
  List<Object?> get props => [userCredential];
}

class OpenEmailAppEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}
