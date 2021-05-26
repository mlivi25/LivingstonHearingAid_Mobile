import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class IAuthenticationRepository {
  Future<User> signInWithGoogle();

  Stream<User> authenticationStatusStream();

  Future<User> signUp(String email, String password);

  Future<void> signOut();

  emailSignIn({String email, String password}) {}
}

class AuthenticationRepository implements IAuthenticationRepository {
  AuthenticationRepository(FirebaseApp firebaseApp) {
    this._auth = FirebaseAuth.instanceFor(app: firebaseApp);
  }

  FirebaseAuth _auth;
  //Use this stream for authentication instead

  Stream<User> authenticationStatusStream() {
    return _auth.authStateChanges();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ignore: missing_return
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );
        return userCredential.user;
      }
    } else {
      throw FirebaseAuthException(
        message: "Sign in aborded by user",
        code: "ERROR_ABORDER_BY_USER",
      );
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<User> signUp(String email, String password) async {
    UserCredential newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return newUser.user;
  }

  @override
  emailSignIn({String email, String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}
