part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final String email;

  const AuthenticationAuthenticated({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {}

class SignUpSuccess extends AuthenticationState {}

class NotSignedUp extends AuthenticationState {}

class SignUpFailure extends AuthenticationState {}
