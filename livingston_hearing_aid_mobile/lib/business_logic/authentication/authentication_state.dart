part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class LoggedOut extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  AuthenticationError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

class ProcessingAuthentication extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;

  Authenticated(this.user);

  @override
  List<Object> get props => [user];
}
