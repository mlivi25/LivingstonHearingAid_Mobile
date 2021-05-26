import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livingston_hearing_aid_mobile/business_logic/authentication/authentication_bloc.dart';
import 'package:livingston_hearing_aid_mobile/data/repositories/auth_repository.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('[Auth_Bloc_Tests]', () {
    AuthenticationBloc sut;
    MockAuthenticationRepo mockAuthRepo;

    StreamController<User> authStatusController;

    setUp(() {
      mockAuthRepo = MockAuthenticationRepo();
      authStatusController = new StreamController<User>();

      when(mockAuthRepo.authenticationStatusStream())
          .thenAnswer((_) => authStatusController.stream);

      when(mockAuthRepo.signInWithGoogle()).thenAnswer((realInvocation) {
        authStatusController.add(MockUser());
        return Future.value(MockUser());
      });

      when(mockAuthRepo.signUp(argThat(isA<String>()), argThat(isA<String>())))
          .thenAnswer((_) {
        return Future.value(MockUser());
      });

      when(mockAuthRepo.emailSignIn(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((realInvocation) => Future.value(MockUser()));

      sut = AuthenticationBloc(authenticationRepo: mockAuthRepo);
    });

    tearDown(() {
      authStatusController.close();
    });

    test('Initial State', () {
      expect(sut.state, LoggedOut());
    });

    blocTest('Auth State Changes',
        build: () => sut,
        act: (bloc) {
          authStatusController.add(MockUser());
        },
        expect: () => [isA<Authenticated>()]);

    blocTest('Google Auth Command Test',
        build: () => sut,
        act: (bloc) {
          bloc.add(GoogleLoginCommand());
        },
        expect: () => [ProcessingAuthentication(), isA<Authenticated>()]);

    blocTest('Create Account Command',
        build: () => sut,
        act: (bloc) {
          bloc.add(CreateAccountCommand(email: 'Email', password: 'Password'));
        },
        expect: () => [isA<Authenticated>()],
        verify: (bloc) {
          verify(mockAuthRepo.signUp('Email', 'Password'));
        });

    blocTest('Email Login Command',
        build: () => sut,
        act: (bloc) {
          bloc.add(EmailLoginCommand(email: 'Email', password: 'Password'));
          authStatusController.add(MockUser());
        },
        expect: () => [ProcessingAuthentication(), isA<Authenticated>()],
        verify: (bloc) {
          verify(
              mockAuthRepo.emailSignIn(email: 'Email', password: 'Password'));
        });
  });
}

class MockAuthenticationRepo extends Mock implements AuthenticationRepository {}

class MockUser extends Mock implements User {}
