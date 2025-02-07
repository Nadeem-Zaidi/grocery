import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/categories/category_bloc/category_bloc.dart';

import '../categories/widgets/category_parent_selection_dialog.dart';
import '../utils/screen_utils.dart';
import '../widget/overlay.dart';

class CreateCategorypage extends StatefulWidget {
  const CreateCategorypage({super.key});

  @override
  State<CreateCategorypage> createState() => _CreateCategorypageState();
}

class _CreateCategorypageState extends State<CreateCategorypage> {
  TextEditingController _categoryNameController = TextEditingController();
  TextEditingController _categoryParentController = TextEditingController();
  TextEditingController _categoryPathController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void setParent(String name, String parent, String path) {}

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      var categoryName = _categoryNameController.text;
      var categoryParent = _categoryParentController.text;
      var categoryPath = _categoryPathController.text;
      Map<String, dynamic> dataToUpdate = {
        "name": categoryName,
        "parent": categoryParent,
        "path": categoryPath
      };
      context
          .read<CategoryBloc>()
          .add(CreateCategory(categoryData: dataToUpdate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final sizedBoxSpacing = screenHeight * 0.020;
    final marginTop = screenHeight * 0.20;
    final paddingAll = screenWidth * 0.030;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: marginTop),
          padding: EdgeInsets.all(paddingAll),
          child: BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state.isLoading) {
                OverlayHelper.showOverlay(context, "Loading");
              }
              if (!state.isLoading) {
                OverlayHelper.removeOverlay();
              }
            },
            builder: (context, state) {
              return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _categoryNameController,
                        decoration: InputDecoration(
                          labelText: "Category Name",
                        ),
                      ),
                      SizedBox(height: sizedBoxSpacing),
                      TextFormField(
                        controller: _categoryParentController,
                        decoration: InputDecoration(
                          labelText: "Select Category Parent",
                          suffixIcon: IconButton(
                            onPressed: () {
                              categoryParentSelectionDialog(context,
                                  screenWidth, screenHeight, setParent);
                            },
                            icon: Icon(Icons.looks),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _categoryPathController,
                        decoration: InputDecoration(
                          labelText: "Category Path",
                          suffixIcon: IconButton(
                            onPressed: () {
                              categoryParentSelectionDialog(context,
                                  screenWidth, screenHeight, setParent);
                            },
                            icon: Icon(Icons.looks),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxSpacing),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                _onSave();
                              },
                              child: Text("Create Category")))
                    ],
                  ));
            },
          ),
        ),
      ),
    );
  }
}
