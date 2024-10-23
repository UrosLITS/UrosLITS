import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_mail_app/open_mail_app.dart';

sealed class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SuccessfulLogin extends LoginState {
  SuccessfulLogin();

  @override
  List<Object?> get props => [];
}

class SuccessfulSignUp extends LoginState {
  SuccessfulSignUp();

  @override
  List<Object?> get props => [];
}

class InitialState extends LoginState {
  InitialState();
}

class LoadingState extends LoginState {
  LoadingState();
}

class LoadedState extends LoginState {
  LoadedState();
}

class ErrorAuthState extends LoginState {
  ErrorAuthState({required this.errorAuth});

  final FirebaseAuthException errorAuth;

  @override
  List<Object?> get props => [errorAuth, Random().nextInt(10000)];
}

class ErrorState extends LoginState {
  ErrorState({required this.error});

  final Exception error;

  @override
  List<Object?> get props => [error, Random().nextInt(10000)];
}

class SignInWithExistingProvider extends LoginState {}

class VerifyEmailState extends LoginState {}

class GoogleSignInState extends LoginState {
  GoogleSignInState({required this.userCredential});

  final UserCredential userCredential;

  @override
  List<Object?> get props => [userCredential];
}

class CreateUserWithGoogleState extends LoginState {
  CreateUserWithGoogleState({required this.userCredential});

  final UserCredential userCredential;

  @override
  List<Object?> get props => [userCredential];
}

class FacebookSignInState extends LoginState {
  FacebookSignInState({required this.userCredential});

  final UserCredential userCredential;

  @override
  List<Object?> get props => [userCredential];
}

class CreateUserWithFacebookState extends LoginState {
  CreateUserWithFacebookState({required this.userCredential});

  final UserCredential userCredential;

  @override
  List<Object?> get props => [userCredential];
}

class CanOpenEmailAppState extends LoginState {
  CanOpenEmailAppState({required this.mailAppResult});

  final OpenMailAppResult mailAppResult;

  @override
  List<Object?> get props => [mailAppResult];
}

class CanNotOpenEmailAppState extends LoginState {}
