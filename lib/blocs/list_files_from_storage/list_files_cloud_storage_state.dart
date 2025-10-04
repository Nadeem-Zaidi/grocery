import 'package:equatable/equatable.dart';

import '../../database_service.dart/storage_service/storage_file_page.dart';

class CloudStorageState extends Equatable {
  final StorageFilePage? files;
  final bool loading;
  final String? error;
  final List<CloudStorageState> history; // stack of previous states

  const CloudStorageState({
    this.files,
    this.loading = false,
    this.error,
    this.history = const [],
  });

  factory CloudStorageState.initial() => CloudStorageState();

  CloudStorageState copyWith({
    StorageFilePage? files,
    bool? loading,
    String? error,
    List<CloudStorageState>? history,
  }) {
    return CloudStorageState(
      files: files ?? this.files,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      history: history ?? this.history,
    );
  }

  bool showReturnButton() => history.length > 1;

  @override
  List<Object?> get props => [files, loading, error, history];
}
