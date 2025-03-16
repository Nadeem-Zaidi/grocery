import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/authentication/domain/user_model.dart';
import 'package:grocery_app/authentication/infrastructure/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late final _authService;
  late StreamSubscription<AuthUserModel> _authUserSubscription;
  AuthCubit() : super(AuthState.empty()) {
    _authService = FireBaseAuthService(FirebaseAuth.instance);
    _authUserSubscription =
        _authService.authStateChanges.listen(_listenAuthStateChangesStream);
  }

  @override
  Future<void> close() async {
    await _authUserSubscription.cancel();
    super.close();
  }

  Future<void> _listenAuthStateChangesStream(
      AuthUserModel authUserModel) async {
    emit(state.copyWith(
        userModel: authUserModel, isUserCheckedFromAuthService: true));
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
