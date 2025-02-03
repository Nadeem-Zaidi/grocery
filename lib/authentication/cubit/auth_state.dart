part of 'auth_cubit.dart';

@immutable
class AuthState {
  final AuthUserModel userModel;
  final bool isUserCheckedFromAuthService;

  const AuthState({
    required this.userModel,
    required this.isUserCheckedFromAuthService,
  });

  AuthState copyWith(
      {AuthUserModel? userModel, bool? isUserCheckedFromAuthService}) {
    return AuthState(
        userModel: userModel ?? this.userModel,
        isUserCheckedFromAuthService:
            isUserCheckedFromAuthService ?? this.isUserCheckedFromAuthService);
  }

  AuthState.empty()
      : userModel = AuthUserModel.empty(),
        isUserCheckedFromAuthService = false;

  // Getter to check if the user is logged in
  bool get isLoggedIn =>
      userModel !=
      AuthUserModel.empty(); // Ensure AuthUserModel overrides equality
}
