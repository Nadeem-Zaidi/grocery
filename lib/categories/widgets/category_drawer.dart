import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/categories/category_bloc/category_bloc.dart';
import 'package:grocery_app/database_service.dart/firestore_category_service.dart';
import 'package:grocery_app/pages/create_category_page.dart';

class CategoryDrawer extends StatefulWidget {
  const CategoryDrawer({super.key});

  @override
  State<CategoryDrawer> createState() => _CategoryDrawerState();
}

class _CategoryDrawerState extends State<CategoryDrawer> {
  FirestoreCategoryService categoryService = FirestoreCategoryService(
      firestore: FirebaseFirestore.instance, collectionName: "categories");
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Text("Wecome User"),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        CategoryBloc(dbService: categoryService),
                    child: CreateCategorypage(),
                  ),
                ),
              );
            },
            child: ListTile(
              leading: Icon(Icons.category),
              title: Text("Create Category"),
            ),
          )
        ],
      ),
    );
  }
}
