import 'dart:io';

import 'package:grocery_app/database_service.dart/storage_service/storage_file_page.dart';
import 'package:grocery_app/database_service.dart/storage_service/upload_provider.dart';

import 'storage_file.dart';

abstract class AStorageService {
  Future<StorageFilePage> listFiles(String path);
  Future<String> getDownloadUrl(String path);
  Future<String> uploadFile(File file, String path,
      [String? folderName, String? uploadName]);
  Future<void> deleteFile(String path);
  Future<List<String>> uploadFiles(List<File> files, String path,
      [String? folderName, String? uploadName]);
}
