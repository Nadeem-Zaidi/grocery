import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../authentication/domain/user_model.dart';

extension FirebaseuseDomain on firebase.User {
  AuthUserModel toDomain() {
    final AuthUserModel emptyModel = AuthUserModel.empty();
    return emptyModel.copyWith(
        id: uid, phoneNumber: phoneNumber ?? emptyModel.phoneNumber);
  }
}
