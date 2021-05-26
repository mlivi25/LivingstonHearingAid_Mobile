part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticatedEvent extends AuthenticationEvent {
  const AuthenticatedEvent({this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

class CreateAccountCommand extends AuthenticationEvent {
  final String email;
  final String password;

  CreateAccountCommand({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class EmailLoginCommand extends AuthenticationEvent {
  final String email;
  final String password;

  EmailLoginCommand({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class LoggedOutEvent extends AuthenticationEvent {}

class LogOutCommand extends AuthenticationEvent {}

class GoogleLoginCommand extends AuthenticationEvent {}

class EmailLoginAttempt extends AuthenticationEvent {}
