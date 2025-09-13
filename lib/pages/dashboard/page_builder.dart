import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/dashboard_bloc/dashboard_bloc.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart'
    as db_section;
import 'package:grocery_app/pages/dashboard/section_builder.dart';
import 'package:grocery_app/pages/dashboard/section_template.dart';
import 'package:grocery_app/widgets/utilities_widget/dialog_box/dialog_box_item.dart';
import 'package:grocery_app/widgets/utilities_widget/dialog_box/dialog_box_list_item.dart';

import '../../widgets/utilities_widget/dialog_box/dialogbox_for_template_selection.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({super.key});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Builder"),
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          // if(state.error!=null){
          //   //error handling
          //   return Center(child: Text(state.error.toString()),);

          // }
          // if(state.sections.isEmpty){
          //   return Center(child: Text("No record exist"),)
          // }
          List<db_section.Section> section = state.sections;
          return SizedBox(
            child: ListView.builder(
              itemCount: section.length,
              itemBuilder: (context, index) {
                return sectionBuilder(section: section[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final parentContext = context;
          showDialog(
              context: parentContext,
              builder: (context) {
                return DialogBoxSectionType(
                  listitems: [
                    ItemWithGoto(
                      name: "Category Section",
                      goTo: () {
                        parentContext.read<DashboardBloc>().add(
                              AddSection(
                                section: db_section.CategorySection(
                                    id: 'testing1',
                                    name: "Grocery & Kitchen",
                                    type: 'category',
                                    sequence: 1),
                              ),
                            );
                        Navigator.pop(parentContext);
                      },
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
