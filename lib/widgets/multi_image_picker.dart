import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/beauty_cosmetics/bloc/form_bloc.dart';
import 'package:grocery_app/blocs/products/product_bloc/product_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grocery_app/blocs/beauty_cosmetics/bloc/form_bloc.dart'
    as formState;

class MultiImageUploadScreen extends StatefulWidget {
  const MultiImageUploadScreen({super.key});

  @override
  State<MultiImageUploadScreen> createState() => _MultiImageUploadScreenState();
}

class _MultiImageUploadScreenState extends State<MultiImageUploadScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Modern pick button with icon
        FilledButton.icon(
          onPressed: () {
            context.read<FormBloc>().add(FormPickImages());
          },
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text("SELECT IMAGES "),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Image grid with elegant card design
        Expanded(
          child: BlocBuilder<FormBloc, formState.FormState>(
            builder: (context, state) {
              if (state.productImages.isNotEmpty) {
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.productImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return _buildImageCard(
                        index, colorScheme, state.productImages);
                  },
                );
              } else {
                return _buildEmptyState(Theme.of(context));
              }
            },
          ),
        ),

        const SizedBox(height: 16),

        // BlocBuilder<FormBloc, formState.FormState>(
        //   builder: (context, state) {
        //     if (state.productImages.isNotEmpty) {
        //       return AnimatedSwitcher(
        //         duration: const Duration(milliseconds: 300),
        //         child: FilledButton(
        //           key: ValueKey(_imageFiles.isEmpty),
        //           onPressed: _imageFiles.isNotEmpty ? () {} : null,
        //           style: FilledButton.styleFrom(
        //             backgroundColor: colorScheme.primary,
        //             foregroundColor: colorScheme.onPrimary,
        //             padding: const EdgeInsets.symmetric(vertical: 16),
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             elevation: 2,
        //           ),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               const Icon(Icons.cloud_upload_outlined),
        //               const SizedBox(width: 8),
        //               Text(
        //                 "UPLOAD (${_imageFiles.length})",
        //                 style: theme.textTheme.labelLarge?.copyWith(
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     }
        //     return _buildEmptyState(Theme.of(context));
        //   },
        // )

        // Upload button with conditional styling
      ],
    );
  }

  Widget _buildImageCard(
      int index, ColorScheme colorScheme, List<XFile> imageFiles) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image with fade-in effect
          Image.file(
            File(imageFiles[index].path),
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: child,
              );
            },
          ),

          // Image index badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Remove button with nice animation
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                context
                    .read<FormBloc>()
                    .add(FormRemovePickedImages(index: index));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: theme.colorScheme.outline.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No images selected",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap the button above to add photos",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
