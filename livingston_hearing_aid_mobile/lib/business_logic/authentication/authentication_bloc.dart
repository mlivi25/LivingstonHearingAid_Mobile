import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livingston_hearing_aid_mobile/data/repositories/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required this.authenticationRepo}) : super(LoggedOut()) {
    this._authSubscription =
        authenticationRepo.authenticationStatusStream().listen((event) {
      if (event == null) {
        add(LoggedOutEvent());
      } else
        add(AuthenticatedEvent(user: event));
    });
  }

  IAuthenticationRepository authenticationRepo;

  StreamSubscription _authSubscription;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is GoogleLoginCommand) {
      yield* googleLogin();
    } else if (event is LogOutCommand) {
      yield* signOut();
    } else if (event is AuthenticatedEvent) {
      yield Authenticated(event.user);
    } else if (event is CreateAccountCommand)
      await createEmailAccount(event);
    else if (event is EmailLoginCommand)
      yield* emailLogin(event);
    else if (event is LoggedOutEvent && state is Authenticated)
      yield LoggedOut();
    else
      yield LoggedOut();
  }

  Stream<AuthenticationState> googleLogin() async* {
    yield ProcessingAuthentication();
    try {
      await authenticationRepo.signInWithGoogle();
    } catch (e) {
      yield AuthenticationError(e);
      yield LoggedOut();
    }
  }

  Stream<AuthenticationState> signOut() async* {
    yield ProcessingAuthentication();
    await authenticationRepo.signOut();
  }

  Future createEmailAccount(CreateAccountCommand event) async {
    User newUser = await authenticationRepo.signUp(event.email, event.password);
    add(AuthenticatedEvent(user: newUser));
  }

  Stream<AuthenticationState> emailLogin(EmailLoginCommand event) async* {
    yield ProcessingAuthentication();
    try {
      await authenticationRepo.emailSignIn(
          email: event.email, password: event.password);
    } catch (e) {
      if (e is FirebaseAuthException)
        yield AuthenticationError(e.message);
      else
        yield AuthenticationError('Unknown Error Occurred. Please Try Again.');
      yield LoggedOut();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    super.onChange(change);
  }

  @override
  void onTransition(
      Transition<AuthenticationEvent, AuthenticationState> transition) {
    super.onTransition(transition);
  }

  @override
  void onEvent(AuthenticationEvent event) {
    super.onEvent(event);
  }
}
