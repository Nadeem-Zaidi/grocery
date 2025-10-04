import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart';
import 'package:grocery_app/widgets/utilities_widget/dialog_box/custom_dialog_box.dart';

import '../../../blocs/list_files_from_storage/list_files_cloud_storage_bloc.dart';
import '../../../blocs/section/dashboard_bloc/dashboard_bloc.dart';
import '../../../blocs/section/sectopm_bloc/section_builder_bloc.dart';
import '../../../database_service.dart/storage_service/storage_provider.dart';
import '../../../database_service.dart/storage_service/upload_provider.dart';
import '../../../models/custom_cards/customcard.dart';
import '../../../pages/cloud_files/cloud_file_list.dart';
import '../../../service_locator/service_locator.dart';
import '../../utilities_widget/dialog_box/dialog_box_item.dart';
import '../../utilities_widget/dialog_box/dialogbox_for_template_selection.dart';

class PageBuilderOptions extends StatefulWidget {
  final BuildContext context; // renamed to avoid shadowing
  const PageBuilderOptions({super.key, required this.context});

  @override
  State<PageBuilderOptions> createState() => _PageBuilderDialogOptionsState();
}

class _PageBuilderDialogOptionsState extends State<PageBuilderOptions> {
  @override
  Widget build(BuildContext context) {
    final dashBloc = widget.context.read<DashboardBloc>();
    void selectAppBarImage(image) {
      dashBloc.add(SelectAppbarImageUrl(imageUrl: image));
      Navigator.pop(widget.context);
    }

    return DialogBoxSectionType(
      listitems: [
        SelectImageWithBlocEvent(
          addEvent: () {
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
                    BlocProvider.value(value: dashBloc),
                  ],
                  child: FileList(
                    onClick: (testing) {
                      selectAppBarImage(testing);
                    },
                  )),
            ));
          },
          name: "Select Appbar Image",
        ),
        ItemWithGoto(
          name: "Category Section",
          goTo: () {
            widget.context.read<DashboardBloc>().add(
                  AddSection(section: CategorySection.initial()),
                );
            Navigator.pop(widget.context);
          },
        ),
        ItemWithGoto(
          name: "Promo Section",
          goTo: () {
            widget.context.read<DashboardBloc>().add(
                  AddPromoBanner(section: AppbarPromotionSection.initial()),
                );
            Navigator.pop(widget.context);
          },
        ),
        ItemWithGoto(
          name: "Promo Section Grid View",
          goTo: () {
            widget.context.read<DashboardBloc>().add(
                  AddPromoBanner(
                    section: AppbarPromotionSection.initial()
                        .copyWith(type: "promogridview"),
                  ),
                );
            Navigator.pop(widget.context);
          },
        ),
      ],
    );
  }
}
