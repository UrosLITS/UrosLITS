import 'package:book/core/constants.dart';
import 'package:book/data/firebase_auth/firebase_auth_singleton.dart';
import 'package:book/data/firebase_firestore/firebase_db_manager.dart';
import 'package:book/models/app_user_singleton.dart';
import 'package:book/presentation/login/bloc/login_event.dart';
import 'package:book/presentation/login/bloc/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_mail_app/open_mail_app.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super((InitialState())) {
    on<Login>(_onLogin);
    on<SignUp>(_onSignUp);
    on<GoogleSignIn>((event, emit) => _onGoogleSignIn(event, emit));
    on<CreateUserWithGoogleAcc>(
        (event, emit) => _CreateUserWithGoogleAcc(event, emit));
    on<SignUpWithProvider>((event, emit) => _SignUpWithProvider(event, emit));
    on<FacebookSignIn>((event, emit) => _onFacebookSignIn(event, emit));
    on<CreateUserWithFacebookAcc>(
        (event, emit) => _onCreateUserWithFacebookAcc(event, emit));
    on<OpenEmailAppEvent>((event, emit) => _onOpenEmailAppEvent(emit));
  }

  Future<void> _onLogin(Login event, Emitter<LoginState> emit) async {
    emit(LoadingState());
    try {
      await FirebaseAuthSingleton.instance.login(event.email, event.password);

      if (FirebaseAuthSingleton.instance.auth.currentUser!.emailVerified) {
        await AppUserSingleton.instance.setUser();

        emit(LoadedState());
        emit(SuccessfulLogin());
      } else {
        emit(LoadedState());
        emit(VerifyEmailState());
      }
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(errorAuth: e));
      emit(LoadedState());
    } on Exception catch (e) {
      emit(ErrorState(error: e));
      emit(LoadedState());
    }
  }

  Future<void> _onSignUp(SignUp event, Emitter<LoginState> emit) async {
    emit(LoadingState());
    try {
      await FirebaseAuthSingleton.instance.registration(event.appUser);
      emit(SuccessfulSignUp());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(errorAuth: e));
    } on Exception catch (e) {
      emit(ErrorState(error: e));
    } finally {
      emit(LoadedState());
    }
  }

  Future<void> _onGoogleSignIn(
      GoogleSignIn event, Emitter<LoginState> emit) async {
    try {
      final result = await FirebaseAuthSingleton.instance.signInWithGoogle();

      if (result != null) {
        emit(GoogleSignInState(userCredential: result));
      }
    } on Exception catch (e) {
      emit(ErrorState(error: e));
    }
  }

  Future<void> _CreateUserWithGoogleAcc(
      CreateUserWithGoogleAcc event, Emitter<LoginState> emit) async {
    try {
      final result = await FirebaseDbManager.instance
          .loginUserWithGoogle(event.userCredential);

      if (result != null) {
        final userResult = await AppUserSingleton.instance.setUser();
        if (userResult != null) {
          emit(SuccessfulLogin());
        }
      } else {
        emit(CreateUserWithGoogleState(userCredential: event.userCredential));
      }
    } on Exception catch (e) {
      emit(ErrorState(error: e));
    }
  }

  Future<void> _SignUpWithProvider(
      SignUpWithProvider event, Emitter<LoginState> emit) async {
    try {
      await FirebaseAuthSingleton.instance.checkEmailVerified();
      await FirebaseAuthSingleton.instance.addUserToDatabase(event.appUser);
      emit(SuccessfulSignUp());
    } on Exception catch (e) {
      emit(ErrorState(error: e));
    }
  }
}

Future<void> _onOpenEmailAppEvent(Emitter<LoginState> emit) async {
  try {
    final mail = await OpenMailApp.openMailApp();
    if (!mail.didOpen && !mail.canOpen) {
      emit(CanNotOpenEmailAppState());
    } else if (!mail.didOpen && mail.canOpen) {
      emit(CanOpenEmailAppState(mailAppResult: mail));
    }
  } on Exception catch (e) {
    emit(ErrorState(error: e));
  }
}

Future<void> _onCreateUserWithFacebookAcc(
    CreateUserWithFacebookAcc event, Emitter<LoginState> emit) async {
  try {
    final result = await FirebaseDbManager.instance
        .loginWithFacebook(event.userCredential);

    if (result != null) {
      final userResult = await AppUserSingleton.instance.setUser();
      if (userResult != null) {
        emit(SuccessfulLogin());
      }
    } else {
      emit(CreateUserWithFacebookState(userCredential: event.userCredential));
    }
  } on Exception catch (e) {
    emit(ErrorState(error: e));
  }
}

Future<void> _onFacebookSignIn(
    FacebookSignIn event, Emitter<LoginState> emit) async {
  try {
    final result = await FirebaseAuthSingleton.instance.signInWithFacebook();

    if (result != null) {
      emit(FacebookSignInState(userCredential: result));
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == sameCredAccount) {
      emit(LoadedState());
      emit(SignInWithExistingProvider());
    }
    emit(ErrorState(error: e));
  }
}
