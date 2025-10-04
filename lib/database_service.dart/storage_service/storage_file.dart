class StorageFile {
  final String fileName;
  final String fileUrl;
  final String bucketName;
  final String fullPath;
  final String? type;

  StorageFile({
    required this.fileName,
    required this.fileUrl,
    required this.bucketName,
    required this.fullPath,
    this.type,
  });

  StorageFile copyWith(
      {String? fileName,
      String? fileUrl,
      String? bucketName,
      String? fullPath,
      String? type}) {
    return StorageFile(
        fileName: fileName ?? this.fileName,
        fileUrl: fileUrl ?? this.fileUrl,
        bucketName: bucketName ?? this.bucketName,
        fullPath: fullPath ?? this.fullPath,
        type: type ?? this.type);
  }
}
