import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/categories/category_bloc/category_bloc.dart';
import 'package:grocery_app/categories/category_parent_dialog_bloc/cubit/category_parent_dialog_cubit.dart';
import 'package:grocery_app/database_service.dart/firestore_category_service.dart';

import '../category.dart';

Future<void> categoryParentSelectionDialog(
    BuildContext context, double width, double height, Function parentData) {
  FirestoreCategoryService categoryService = FirestoreCategoryService(
      firestore: FirebaseFirestore.instance, collectionName: "categories");
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider<CategoryParentDialogCubit>(
          create: (context) =>
              CategoryParentDialogCubit(dbService: categoryService)
                ..fetchCategories(),
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.012)),
              child: Container(
                height: height * 0.6,
                width: double.infinity,
                child: BlocBuilder<CategoryParentDialogCubit,
                    CategoryParentDialogState>(
                  builder: (context, state) {
                    if (state.isLoading == true) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.categories.isNotEmpty) {
                      List<Category> categories =
                          state.categories as List<Category>;
                      return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                parentData(
                                    categories[index].name,
                                    categories[index].parent,
                                    categories[index].path);
                              },
                              child: ListTile(
                                title: Text(categories[index].name),
                                subtitle: Text(categories[index].path ?? ""),
                              ),
                            );
                          });
                    }
                    if (state.categories.isEmpty) {
                      return Center(child: Text("No data in database"));
                    }
                    return Container(
                      child: Center(
                        child: Text("Some thing went wrong"),
                      ),
                    );
                  },
                ),
              )),
        );
      });
}
