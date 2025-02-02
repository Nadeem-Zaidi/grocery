import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grocery_app/authentication/domain/auth_failure.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
}
