import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/card/customcard/customcard_bloc.dart';

import '../blocs/list_files_from_storage/list_files_cloud_storage_bloc.dart';
import '../blocs/section/sectopm_bloc/section_builder_bloc.dart';
import '../database_service.dart/storage_service/storage_provider.dart';
import '../database_service.dart/storage_service/upload_provider.dart';
import '../models/custom_cards/customcard.dart';
import '../pages/cloud_files/cloud_file_list.dart';
import '../service_locator/service_locator.dart';
import '../views/plain_card_view.dart';

class PlainCardBuilder extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final String? hexColor;
  final int index;
  final Color? color;
  final double cardHeight;
  final double cardWidth;

  const PlainCardBuilder({
    super.key,
    this.title,
    this.imageUrl,
    this.hexColor,
    required this.index,
    required this.cardHeight,
    required this.cardWidth,
    this.color,
  });

  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'ff$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return PlainCardView(
      key: ValueKey(index),
      title: title,
      imageUrl: imageUrl,
      backgroundColor: color ?? hexToColor(hexColor ?? "#FF9E9E9E"),
      cardHeight: cardHeight,
      cardWidth: cardWidth,
      onSelectImage: () => context.read<CustomCardBloc>().add(SelectImage()),
      onRemoveImage: () => context.read<CustomCardBloc>().add(RemoveImage()),
      onChangebackGround: () {},
      onSelectFromCloud: (url) {
        final bloc = context;
        void selectImage(String imageUrl) {
          bloc.read<SectionBuilderBloc>().add(
              AddImageToContent<PlainCard>(index: index, imageUrl: imageUrl));

          Navigator.pop(bloc);
        }

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
                BlocProvider.value(value: bloc.read<SectionBuilderBloc>()),
              ],
              child: FileList(
                onClick: (testing) {
                  selectImage(testing);
                },
              )),
        ));
      },
    );
  }
}
