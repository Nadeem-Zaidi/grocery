import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/list_files_from_storage/list_files_cloud_storage_bloc.dart';
import 'package:grocery_app/blocs/section/dashboard_bloc/dashboard_bloc.dart';
import 'package:grocery_app/widgets/overlay.dart';

import '../../blocs/list_files_from_storage/list_files_cloud_storage_state.dart';

class FileList extends StatefulWidget {
  final Function(String imageUrl) onClick;

  const FileList({super.key, required this.onClick});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: const Text("Image Gallery"),
      ),
      body: BlocConsumer<CloudStorageBloc, CloudStorageState>(
        listener: (context, state) {
          if (state.loading == true) {
            OverlayHelper.showOverlay(context, "Loading Content");
          } else {
            OverlayHelper.removeOverlay();
          }
        },
        builder: (context, state) {
          if (state.files == null || state.files!.files.isEmpty) {
            return const Center(
              child: Text(
                "No images to show",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: state.files!.files.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // two columns
                childAspectRatio: 1, // square cards
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final file = state.files!.files[index];
                if (file.type == "reference") {
                  return GestureDetector(
                    onTap: () {
                      context
                          .read<CloudStorageBloc>()
                          .add(GetAllCloudFiles(path: file.fullPath));
                    },
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.folder,
                            size: 50,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          "/${file.fullPath}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    widget.onClick(file.fileUrl);

                    // showDialog(
                    //   context: context,
                    //   builder: (_) => Dialog(
                    //     child: InteractiveViewer(
                    //       child: Image.network(file.fileUrl),
                    //     ),
                    //   ),
                    // );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          file.fileUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 40),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            child: Text(
                              file.fileName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<CloudStorageBloc, CloudStorageState>(
        builder: (context, state) {
          return state.showReturnButton()
              ? FloatingActionButton(
                  onPressed: () {
                    context.read<CloudStorageBloc>().add(PreviousEvent());
                  },
                  child: Icon(Icons.arrow_circle_left_rounded),
                )
              : SizedBox.shrink();
        },
      ),
    );
  }
}
