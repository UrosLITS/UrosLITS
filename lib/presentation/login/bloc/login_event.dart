import 'package:book/models/app_user.dart';
import 'package:equatable/equatable.dart';

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
