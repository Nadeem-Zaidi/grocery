import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/create_category_bloc/category_create_bloc.dart';
import 'package:grocery_app/blocs/categories/category_parent_dialog_bloc/cubit/category_parent_dialog_cubit.dart';
import 'package:grocery_app/database_service.dart/category/firestore_category_service.dart';

import '../models/category.dart';

Future<void> categoryParentSelectionDialog(
    BuildContext context, double width, double height) {
  print("running categoryParentSelectionDialog");
  final categoryPathStringCubit = context.read<CreateCategoryBloc>();
  final categoryParentDialogCubit = context.read<CategoryParentDialogCubit>();

  FirestoreCategoryService categoryService = FirestoreCategoryService(
      firestore: FirebaseFirestore.instance, collectionName: "categories");
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: categoryParentDialogCubit),
          BlocProvider.value(
            value: categoryPathStringCubit, // Use the existing cubit
          ),
        ],
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.012)),
          child: SizedBox(
            height: height * 0.6,
            width: double.infinity,
            child: BlocBuilder<CategoryParentDialogCubit,
                CategoryParentDialogState>(
              builder: (context, state) {
                if (state.categories.isNotEmpty) {
                  var categories = state.categories as List<Category>;

                  return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context.read<CreateCategoryBloc>().add(
                                  Setpath(
                                      fixed: categories[index].path ?? "",
                                      parentId: categories[index].id ?? ""),
                                );
                            Navigator.of(context).pop();
                          },
                          child: ListTile(
                            title: Text(categories[index].name ?? ""),
                            subtitle: Text(categories[index].path ?? ""),
                          ),
                        );
                      });
                }
                return Container();
              },
            ),
          ),
        ),
      );
    },
  );
}
