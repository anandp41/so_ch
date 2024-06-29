part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LogIn extends AuthenticationEvent {
  final String email;
  final String password;
  const LogIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogOut extends AuthenticationEvent {}

class SignUp extends AuthenticationEvent {
  final String email;
  final String password;

  const SignUp({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
