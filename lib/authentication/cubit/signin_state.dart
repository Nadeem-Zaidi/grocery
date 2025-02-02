part of 'signin_cubit.dart';

@immutable
class SigninState {
  final String phoneNumber;
  final String smsCode;
  final Option<AuthFailure> failureOptions;
  final Option<String> verificationIdOption;
  final bool isInProgress;

  const SigninState(
      {required this.phoneNumber,
      required this.smsCode,
      required this.failureOptions,
      required this.verificationIdOption,
      required this.isInProgress});

  factory SigninState.initial() {
    return SigninState(
        phoneNumber: '',
        smsCode: '',
        failureOptions: none(),
        verificationIdOption: none(),
        isInProgress: false);
  }

  SigninState copyWith(
      {String? phoneNumber,
      String? smsCode,
      Option<AuthFailure>? failureOptions,
      Option<String>? verificationOption,
      bool? isInProgress}) {
    return SigninState(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        smsCode: smsCode ?? this.smsCode,
        failureOptions: failureOptions ?? this.failureOptions,
        verificationIdOption: this.verificationIdOption,
        isInProgress: isInProgress ?? this.isInProgress);
  }

  bool get displayNextButton => verificationIdOption.isNone() && !isInProgress;
  bool get displaySmsCodeForm => verificationIdOption.isSome();
  bool get displayLoadingIndicator => !displayNextButton && !displaySmsCodeForm;

  @override
  List<Object?> get props => [
        phoneNumber,
        smsCode,
        failureOptions,
        verificationIdOption,
        isInProgress,
      ];
}
