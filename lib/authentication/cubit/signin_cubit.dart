import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grocery_app/authentication/domain/auth_failure.dart';
import 'package:grocery_app/authentication/domain/iauthservice.dart';
import 'package:grocery_app/authentication/infrastructure/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  late final IAuthService _authService;
  StreamSubscription<Either<AuthFailure, String>>?
      _phoneNumberSignInSubscription;
  final Duration verificationCodeTimeout = const Duration(seconds: 60);
  SigninCubit() : super(SigninState.initial()) {
    _authService = FireBaseAuthService(FirebaseAuth.instance);
  }

  void smsCodeChanged({required String smsCode}) {
    emit(state.copyWith(smsCode: smsCode));
  }

  void phoneNumberChanged({required String phoneNumber}) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void signInWithPhoneNumber() {
    emit(state.copyWith(isInProgress: true, failureOptions: none()));
    _phoneNumberSignInSubscription = _authService
        .signInWithPhoneNumber(
            phoneNumber: state.phoneNumber, timeout: verificationCodeTimeout)
        .listen(
      (Either<AuthFailure, String> failureOrVerificationId) {
        failureOrVerificationId.fold(
          (AuthFailure failure) {
            emit(state.copyWith(
                failureOptions: Some(failure), isInProgress: false));
          },
          (String verificationId) {
            emit(state.copyWith(
                verificationOption: Some(verificationId), isInProgress: false));
          },
        );
      },
    );
  }

  void verifySmsCode() {
    state.verificationIdOption.fold(
      () {},
      (String verificationId) async {
        emit(
          state.copyWith(
            isInProgress: true,
            failureOptions: none(),
          ),
        );
        final Either<AuthFailure, Unit> failureOrSuccess =
            await _authService.verifySmsCode(
                smsCode: state.smsCode, verificationId: verificationId);
        failureOrSuccess.fold((AuthFailure failure) {
          emit(state.copyWith(
              failureOptions: Some(failure), isInProgress: false));
        }, (_) {
          emit(state.copyWith(isInProgress: false));
        });
      },
    );
  }

  @override
  Future<void> close() async {
    await _phoneNumberSignInSubscription?.cancel();
    return super.close();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void reset() {
    emit(
      state.copyWith(
        failureOptions: none(),
        verificationOption: none(),
        isInProgress: false,
      ),
    );
  }
}
