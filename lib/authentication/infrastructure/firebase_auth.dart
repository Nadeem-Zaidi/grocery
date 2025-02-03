import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/unit.dart';
import 'package:grocery_app/authentication/domain/auth_failure.dart';
import 'package:grocery_app/authentication/domain/iauthservice.dart';
import 'package:grocery_app/extensions/firebase_mapper.dart';

import '../domain/user_model.dart';

class FireBaseAuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth;

  FireBaseAuthService(this._firebaseAuth);

  @override
  Stream<Either<AuthFailure, String>> signInWithPhoneNumber(
      {required String phoneNumber, required Duration timeout}) async* {
    // initializing the stream controller
    final StreamController<Either<AuthFailure, String>> streamController =
        StreamController<Either<AuthFailure, String>>();

    await _firebaseAuth.verifyPhoneNumber(
        timeout: timeout,
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          late final Either<AuthFailure, String> result;
          if (e.code == 'invalid-phone-number') {
            result = left(const AuthFailure.invalidPhoneNumber());
          } else if (e.code == 'too-many-requests') {
            result = left(const AuthFailure.tooManyRequests());
          } else if (e.code == 'app-not-authorized') {
            result = left(const AuthFailure.deviceNotSupported());
          } else if (e.code == 'server-error') {
            result = left(const AuthFailure.serverError());
          } else if (e.code == 'Invalid format.') {
            result = left(const AuthFailure.invalidFormat());
          } else {
            result = left(AuthFailure.genericError(
                e.code ?? "Something went wrong in authentication"));
          }
          streamController.add(result);
        },
        codeSent: (String verificationId, int? resendToken) {
          streamController.add(right(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          streamController.add(left(const AuthFailure.smsTimeout()));
        });

    yield* streamController.stream;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<Either<AuthFailure, Unit>> verifySmsCode(
      {required String smsCode, required String verificationId}) async {
    try {
      final PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == "session-expired") {
        return left(const AuthFailure.sessionExpired());
      } else if (e.code == "ınvalıd-verıfıcatıon-code" ||
          e.code == "invalid-verification-code") {
        return left(const AuthFailure.invalidVerificationCode());
      }
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Stream<AuthUserModel> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((User? user) {
      if (user == null) {
        return AuthUserModel.empty();
      } else {
        return user.toDomain();
      }
    });
  }
}
