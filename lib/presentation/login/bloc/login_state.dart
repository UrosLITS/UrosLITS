import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth_platform_interface/src/firebase_auth_exception.dart';

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
