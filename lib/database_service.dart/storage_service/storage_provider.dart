import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:grocery_app/blocs/products/product_bloc/product_bloc.dart';
import 'package:grocery_app/database_service.dart/storage_service/astorage.dart';
import 'package:grocery_app/database_service.dart/storage_service/storage_file_page.dart';
import 'package:mime/mime.dart';

import 'storage_file.dart';
import 'upload_provider.dart';

class StorageProvider implements AStorageService {
  final SStorageProvider storegeProvider;

  StorageProvider({required this.storegeProvider});
  @override
  Future<StorageFilePage> listFiles(String path,
      [int? maxResult = 20, String? pageToken]) async {
    try {
      switch (storegeProvider) {
        case FireBaseStorageProvider f:
          final storage = f.firebaseStorage;
          final result = await storage.ref(path).list(
                ListOptions(maxResults: 20, pageToken: pageToken),
              );

          List<StorageFile> files =
              await Future.wait(result.items.map((ref) async {
            final url = await ref.getDownloadURL();
            return StorageFile(
                fileName: ref.name,
                fileUrl: url,
                bucketName: ref.bucket,
                fullPath: ref.fullPath,
                type: "image");
          }));

          List<StorageFile> prefixes = result.prefixes
              .map((ref) => StorageFile(
                  fileName: ref.name,
                  fileUrl: "",
                  bucketName: ref.bucket,
                  fullPath: ref.fullPath,
                  type: "reference"))
              .toList();
          if (prefixes.isNotEmpty) {
            files = [...files, ...prefixes];
          }

          return StorageFilePage(
              files: files, pageTokens: result.nextPageToken);

        case AwsS3():
          throw UnimplementedError();
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> uploadFile(File s, String path,
      [String? foldername, String? uploadName]) async {
    try {
      if (!isValidImage(s)) {
        throw Exception(
            "Not a valid image.Only (.jpg,.png,.jpeg,webp,.svg formats are allowed)");
      }

      String name = (uploadName == null)
          ? s.path.toString().split("/").last.toLowerCase().trim()
          : uploadName;
      String fullPath = (foldername == null)
          ? "$path/$name".toLowerCase().trim()
          : "$path/$foldername/$name".toLowerCase().trim();
      switch (storegeProvider) {
        case FireBaseStorageProvider(firebaseStorage: FirebaseStorage storage):
          Reference ref = storage.ref().child(fullPath);
          UploadTask uploadTask = ref.putFile(s);
          TaskSnapshot taskSnapshot = await uploadTask;
          return await taskSnapshot.ref.getDownloadURL();
        case AwsS3():
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<String>> uploadFiles(List<File> files, String path,
      [String? folderName, String? uploadName]) async {
    try {
      List<String> uploadedImageUrls = [];
      if (files.isEmpty) {
        throw Exception("Empty list provided");
      }
      for (File f in files) {
        String imageurl = await uploadFile(f, path, folderName, uploadName);
        uploadedImageUrls.add(imageurl);
      }
      return uploadedImageUrls;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> deleteFile(String path) {
    // TODO: implement deleteFile
    throw UnimplementedError();
  }

  @override
  Future<String> getDownloadUrl(String path) {
    // TODO: implement getDownloadUrl
    throw UnimplementedError();
  }

  bool isValidImage(File file) {
    try {
      final mimeType = lookupMimeType(file.path);
      if (mimeType == null || !mimeType.contains("image/")) {
        return false;
      }
      final allowedExtensions = ["jpg", "jpeg", "webp", "png", "svg"];
      final extension =
          file.path.toString().split(".").last.toLowerCase().trim();
      return allowedExtensions.contains(extension);
    } catch (_) {
      return false;
    }
  }
}
