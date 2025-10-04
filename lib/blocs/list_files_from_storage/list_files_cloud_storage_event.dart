part of 'list_files_cloud_storage_bloc.dart';

sealed class CloudStorageEvents extends Equatable {
  const CloudStorageEvents();

  @override
  List<Object> get props => [];
}

@immutable
class GetAllCloudFiles extends CloudStorageEvents {
  final String? path;
  const GetAllCloudFiles({this.path});
}

@immutable
class PreviousEvent extends CloudStorageEvents {}
