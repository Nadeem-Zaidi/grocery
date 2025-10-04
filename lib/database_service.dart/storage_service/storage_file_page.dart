import 'package:grocery_app/database_service.dart/storage_service/storage_file.dart';

class StorageFilePage {
  final List<StorageFile> files;
  final String? pageTokens;
  final List<String> prefix;

  StorageFilePage(
      {this.files = const [], this.pageTokens, this.prefix = const []});

  StorageFilePage copyWith(
      {List<StorageFile>? files, String? pageTokens, List<String>? prefix}) {
    return StorageFilePage(
        files: files ?? this.files,
        pageTokens: pageTokens ?? this.pageTokens,
        prefix: prefix ?? this.prefix);
  }
}
