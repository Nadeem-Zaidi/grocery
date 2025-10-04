import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/list_files_from_storage/list_files_cloud_storage_bloc.dart';
import 'package:grocery_app/pages/cloud_files/cloud_file_list.dart';
import 'package:grocery_app/widgets/templates/page_builder/section_types.dart';

import '../../../database_service.dart/storage_service/storage_provider.dart';
import '../../../database_service.dart/storage_service/upload_provider.dart';
import '../../../service_locator/service_locator.dart';

class PageBuilderBottomNavigatorBar extends StatelessWidget {
  const PageBuilderBottomNavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final parentContext = context;
                showDialog(
                  context: parentContext,
                  builder: (context) =>
                      PageBuilderOptions(context: parentContext),
                );
                // Show info
              },
            ),
            IconButton(
              icon: const Icon(Icons.image),
              onPressed: () {
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
                        )
                      ],
                      child: FileList(
                        onClick: (testing) {},
                      )),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
