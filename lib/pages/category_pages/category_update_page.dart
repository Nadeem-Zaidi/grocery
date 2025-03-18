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
  @override
  Widget build(BuildContext context) {
    TextEditingController _categoryname = TextEditingController();

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
              Text(
                "Update Image",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.grey.shade600),
              ),
              WImagePickerUpdate(),
              SizedBox(height: 10),
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
                      onPressed: () {},
                      icon: Icon(Icons.arrow_drop_down),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.030,
              ),
              TextFormField(
                controller: _categoryname,
                decoration: InputDecoration(
                  labelText: "Category Name",
                ),
                onChanged: (value) {},
              )
            ],
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
      ),
    );
  }
}
