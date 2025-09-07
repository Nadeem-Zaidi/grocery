import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImage(String folderName, File image, String name) async {
  try {
    String? downloadUrl;
    String fileName =
        "$name-${DateTime.now().millisecondsSinceEpoch.toString()}";
    Reference storageRef =
        FirebaseStorage.instance.ref().child("$folderName/$fileName.jpg");
    UploadTask uploadtask = storageRef.putFile(image);
    TaskSnapshot snapShot = await uploadtask;
    downloadUrl = await snapShot.ref.getDownloadURL();
    if (downloadUrl.isEmpty || downloadUrl == null) {
      throw Exception(
          "Seomething went wrong wile uploading image to folder $folderName with name $fileName");
    }
    return downloadUrl;
  } catch (e) {
    print("Upload failed: $e");
    rethrow;
  }
}
