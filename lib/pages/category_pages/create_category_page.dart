import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/categories/create_category_bloc/category_create_bloc.dart';
import 'package:grocery_app/categories/category_parent_dialog_bloc/cubit/category_parent_dialog_cubit.dart';
import 'package:grocery_app/widgets/image_picker.dart';
import 'package:grocery_app/widgets/overlay.dart';
import '../../widgets/category_path_string.dart';
import '../../widgets/category_parent_selection_dialog.dart';
import '../../utils/screen_utils.dart';

class CreateCategorypage extends StatefulWidget {
  const CreateCategorypage({super.key});

  @override
  State<CreateCategorypage> createState() => _CreateCategorypageState();
}

class _CreateCategorypageState extends State<CreateCategorypage> {
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryParentController =
      TextEditingController();
  final TextEditingController _categoryPathController = TextEditingController();
  String parentPath = "";
  String pathString = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  void setParent() {
    _categoryNameController.text = "";
  }

  String current = "";

  void _onSave() async {
    var state = context.read<CreateCategoryBloc>().state;
    context.read<CreateCategoryBloc>().add(CreateCategory());

    // if (_formKey.currentState!.validate()) {
    //   var categoryName = _categoryNameController.text;

    //   Map<String, dynamic> dataToUpdate = {
    //     "name": categoryName,
    //     "parent": categoryName == "self" ? "",
    //     "path":
    //         categoryName == "self" ? "/$categoryName" : stateData.categoryPath,
    //   };

    //   // ignore: use_build_context_synchronously
    // }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final sizedBoxSpacing = screenHeight * 0.020;
    final marginTop = screenHeight * 0.20;
    final paddingAll = screenWidth * 0.030;
    final paddingPathContainer = screenWidth * 0.020;
    final borderRadiusPathContainer = screenWidth * 0.020;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Category",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white)),
      ),
      body: BlocListener<CreateCategoryBloc, CreateCategoryState>(
        listener: (context, state) {
          // if (state.isLoading) {
          //   OverlayHelper.showOverlay(context, "Saving");
          // } else {
          //   OverlayHelper.removeOverlay();
          // }

          if (state.categories.isNotEmpty) {
            print("Categories are not empty, popping the navigator");
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: marginTop),
            padding: EdgeInsets.all(paddingAll),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Select Image",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 10),
                    WImagePicker(create: false),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select Parent Category"),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<CategoryParentDialogCubit>()
                                  .fetchCategories();
                              categoryParentSelectionDialog(context,
                                  screenWidth, screenHeight, setParent);
                            },
                            icon: Icon(Icons.arrow_drop_down),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.030,
                    ),
                    CategoryStringpath(),
                    TextFormField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        labelText: "Category Name",
                      ),
                      onChanged: (value) {
                        context.read<CreateCategoryBloc>().add(
                              UpdateCategoryPath(userInput: value),
                            );
                      },
                    )
                  ],
                )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onSave();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
