import 'package:book/data/firebase_auth/firebase_auth_singleton.dart';
import 'package:book/models/app_user_singleton.dart';
import 'package:book/presentation/login/bloc/login_event.dart';
import 'package:book/presentation/login/bloc/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super((InitialState())) {
    on<Login>(_onLogin);
    on<SignUp>(_onSignUp);
  }

  Future<void> _onLogin(Login event, Emitter<LoginState> emit) async {
    emit(LoadingState());
    try {
      await FirebaseAuthSingleton.instance.login(event.email, event.password);
      final result = await AppUserSingleton.instance.downloadCurrentUser();
      if (result != null) {
        emit(LoadedState());
        emit(SuccessfulLogin());
      } else {}
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
}
