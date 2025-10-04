import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/card/customcard/customcard_bloc.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/models/custom_cards/customcard.dart';

import '../../blocs/list_files_from_storage/list_files_cloud_storage_bloc.dart';
import '../../database_service.dart/storage_service/storage_provider.dart';
import '../../database_service.dart/storage_service/upload_provider.dart';
import '../../pages/cloud_files/cloud_file_list.dart';
import '../../service_locator/service_locator.dart';
import '../utilities_widget/dialog_box/custom_dialog_box.dart';

class PromoCard extends StatefulWidget {
  final String? title;
  final String? imageUrl;
  final String? hexColor;
  final int? index;

  const PromoCard(
      {super.key, this.title, this.imageUrl, this.hexColor, this.index});

  @override
  State<PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<PromoCard> {
  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'ff$hex'; // assume fully opaque
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImageUrl =
        widget.imageUrl != null && widget.imageUrl!.trim().isNotEmpty;

    return BlocBuilder<CustomCardBloc, CustomCardState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                hexToColor(widget.hexColor ?? "#FF9E9E9E"),
                theme.colorScheme.surfaceVariant.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImageContent(context, state, hasImageUrl, theme,
                    widget.imageUrl, widget.index),

                // Optional overlay text/title
                if (widget.title != null && widget.title!.isNotEmpty)
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Text(
                      widget.title!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  right: 1,
                  top: 1,
                  child: GestureDetector(
                    onTap: () {
                      context.read<CustomCardBloc>().add(RemoveImage());
                    },
                    child: Icon(
                      Icons.remove_circle,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContent(BuildContext context, CustomCardState state,
      bool hasImageUrl, ThemeData theme, String? imageUrl, int? index) {
    final bloc = context;
    void selectImage(String imageUrl) {
      bloc
          .read<SectionBuilderBloc>()
          .add(AddImageToContent<PlainCard>(index: index!, imageUrl: imageUrl));

      Navigator.pop(bloc);
    }

    if (state.imageFile != null) {
      // Show picked image (local file)
      return Image.file(
        File(state.imageFile!.path),
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      );
    } else {
      // Show placeholder
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<CustomCardBloc>().add(SelectImage());
            },
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 60,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => CloudStorageBloc(
                          storageProvider: StorageProvider(
                            storegeProvider: FireBaseStorageProvider(
                              firebaseStorage:
                                  ServiceLocator().get<FirebaseStorage>(),
                            ),
                          ),
                        )..add(GetAllCloudFiles()),
                      ),
                      BlocProvider.value(
                          value: bloc.read<SectionBuilderBloc>()),
                    ],
                    child: FileList(
                      onClick: (testing) {
                        selectImage(testing);
                      },
                    )),
              ));
            },
            child: Center(
              child: Icon(
                Icons.link_rounded,
                size: 60,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
        ],
      );
    }
  }
}
