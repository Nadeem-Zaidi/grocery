import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/database_service.dart/storage_service/storage_file.dart';
import 'package:grocery_app/database_service.dart/storage_service/storage_file_page.dart';
import 'package:grocery_app/database_service.dart/storage_service/storage_provider.dart';

import 'list_files_cloud_storage_state.dart';

part 'list_files_cloud_storage_event.dart';

class CloudStorageBloc extends Bloc<CloudStorageEvents, CloudStorageState> {
  StorageProvider storageProvider;
  CloudStorageBloc({required this.storageProvider})
      : super(CloudStorageState.initial()) {
    on<GetAllCloudFiles>(_fetchCloudStorageFiles);
    on<PreviousEvent>(_previousState);
  }

  Future<void> _fetchCloudStorageFiles(
      GetAllCloudFiles event, Emitter<CloudStorageState> emit) async {
    try {
      emit(state.copyWith(loading: true));

      StorageFilePage files =
          await storageProvider.listFiles(event.path ?? "/");

      emit(
        state.copyWith(
          loading: false,
          files: files,
          history: [...state.history, state], // push current state into history
        ),
      );
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> _previousState(
      PreviousEvent event, Emitter<CloudStorageState> emit) async {
    if (state.history.isNotEmpty && state.history.length > 1) {
      final previousState = state.history.last;
      final newHistory = List<CloudStorageState>.from(state.history)
        ..removeLast();
      emit(previousState.copyWith(history: newHistory, loading: false));
    }
  }
}
