import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../categories/category_update/category_update_bloc.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/image_picker.dart';
import '../../widgets/image_picker_update.dart';

class CategoryUpdatePage extends StatefulWidget {
  const CategoryUpdatePage({super.key});

  @override
  State<CategoryUpdatePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CategoryUpdatePage> {
  TextEditingController _categoryname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? path = context.read<CategoryUpdateBloc>().state.existingPath;

    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final sizedBoxSpacing = screenHeight * 0.020;
    final marginTop = screenHeight * 0.20;
    final paddingAll = screenWidth * 0.030;
    final paddingPathContainer = screenWidth * 0.020;
    final borderRadiusPathContainer = screenWidth * 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Category",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: marginTop),
          padding: EdgeInsets.all(paddingAll),
          child: Form(
              child: Column(
            children: [
              BlocBuilder<CategoryUpdateBloc, CategoryUpdateState>(
                builder: (context, state) {
                  if (state.existingPath != null) {
                    return Text(
                      "Update Image",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.grey.shade600),
                    );
                  }
                  return Container();
                },
              ),
              WImagePickerUpdate(),
              SizedBox(height: 10),
              SizedBox(height: 20),
              BlocBuilder<CategoryUpdateBloc, CategoryUpdateState>(
                builder: (context, state) {
                  if (state.pathName != null) {
                    return Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(state.pathName ?? "")),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(
                height: screenHeight * 0.030,
              ),
              BlocBuilder<CategoryUpdateBloc, CategoryUpdateState>(
                builder: (context, state) {
                  return TextFormField(
                    controller: _categoryname,
                    decoration:
                        InputDecoration(hintText: "Enter Category Name"),
                    onChanged: (value) {
                      context
                          .read<CategoryUpdateBloc>()
                          .add(UpdateExistingName(value: value));
                    },
                  );
                },
              )
            ],
          )),
        ),
      ),
      floatingActionButton:
          BlocBuilder<CategoryUpdateBloc, CategoryUpdateState>(
        builder: (context, state) {
          if (state.shouldChange == true && state.dynamicPath!.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () {
                context.read<CategoryUpdateBloc>().add(UpdateCategory());
              },
              child: Icon(Icons.save),
            );
          }
          return Container();
        },
      ),
    );
  }
}
