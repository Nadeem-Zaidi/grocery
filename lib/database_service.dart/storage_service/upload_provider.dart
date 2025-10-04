import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

sealed class SStorageProvider {}

class FireBaseStorageProvider extends SStorageProvider {
  FirebaseStorage firebaseStorage;
  FireBaseStorageProvider({required this.firebaseStorage});
}

class AwsS3 extends SStorageProvider {}
