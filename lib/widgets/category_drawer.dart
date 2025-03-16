import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/categories/create_category_bloc/category_create_bloc.dart';
import 'package:grocery_app/categories/fetch_category_bloc/fetch_category_bloc.dart';

import 'package:grocery_app/pages/category_pages/categories.dart';
import 'package:grocery_app/pages/category_pages/create_category_page.dart';

import '../categories/category_parent_dialog_bloc/cubit/category_parent_dialog_cubit.dart';
import '../database_service.dart/firestore_category_service.dart';

class CategoryDrawer extends StatefulWidget {
  const CategoryDrawer({super.key});

  @override
  State<CategoryDrawer> createState() => _CategoryDrawerState();
}

class _CategoryDrawerState extends State<CategoryDrawer> {
  FirestoreCategoryService categoryService = FirestoreCategoryService(
    firestore: FirebaseFirestore.instance,
    collectionName: "categories",
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text("Welcome User"),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<CategoryParentDialogCubit>(
                          create: (context) => CategoryParentDialogCubit(
                              dbService: categoryService)),
                      BlocProvider(
                          create: (context) =>
                              CreateCategoryBloc(dbService: categoryService))
                    ],
                    child: const CreateCategorypage(),
                  ),
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.category),
              title: Text("Create Category"),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => FetchCategoryBloc(categoryService)
                      ..add(FetchCategories()),
                    child: CategoriesPage(),
                  ),
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.list),
              title: Text("Categories"),
            ),
          ),
        ],
      ),
    );
  }
}
