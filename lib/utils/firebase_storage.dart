import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImage(File image) async {
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child("images/$fileName.jpg");
    UploadTask uploadtask = storageRef.putFile(image);
    TaskSnapshot snapShot = await uploadtask;
    String downloadUrl = await snapShot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Upload failed: $e");
    return null;
  }
}
