import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../core/strings.dart';
import '../user_model/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Box _authBox = Hive.box(hiveAuthBoxName);
  final Box<UserModel> _userBox = Hive.box<UserModel>(hiveUsersBox);
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LogIn>(_onLogIn);
    on<LogOut>(_onLogOut);
    on<SignUp>(_onSignUp);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthenticationState> emit) {
    final email = _authBox.get(loggedInEmail);
    if (email != null) {
      emit(AuthenticationAuthenticated(email: email));
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onLogIn(LogIn event, Emitter<AuthenticationState> emit) async {
    final user = _userBox.values.firstWhere(
      (user) => user.email == event.email && user.password == event.password,
      orElse: () => UserModel(email: '', password: ''),
    );

    if (user.email.isNotEmpty) {
      _authBox.put(loggedInEmail, event.email);
      emit(AuthenticationAuthenticated(email: event.email));
    } else {
      emit(AuthenticationFailure());
      log('emit failure');
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onLogOut(
      LogOut event, Emitter<AuthenticationState> emit) async {
    await _authBox.delete(loggedInEmail);
    emit(AuthenticationUnauthenticated());
  }

  Future<void> _onSignUp(
      SignUp event, Emitter<AuthenticationState> emit) async {
    final existingUser = _userBox.values.firstWhere(
      (user) => user.email == event.email,
      orElse: () => UserModel(email: '', password: ''),
    );

    if (existingUser.email.isEmpty) {
      final newUser = UserModel(email: event.email, password: event.password);
      await _userBox.add(newUser);
      emit(SignUpSuccess());
    } else {
      emit(SignUpFailure());
    }
  }
}
