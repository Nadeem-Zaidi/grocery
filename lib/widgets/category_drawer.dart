import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/create_category_bloc/category_create_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/blocs/products/product_bloc/product_bloc.dart';
import 'package:grocery_app/database_service.dart/inventory/firebase_inventory_service.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';

import 'package:grocery_app/pages/category_pages/categories.dart';
import 'package:grocery_app/pages/product_pages/create_product.dart';

import '../database_service.dart/category/firestore_category_service.dart';

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
              Navigator.of(context).pushNamed("/createcategory");
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
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => FetchCategoryBloc(
                            FirestoreCategoryService(
                                firestore: FirebaseFirestore.instance,
                                collectionName: "categories"),
                            FirestoreProductService(
                                fireStore: FirebaseFirestore.instance,
                                collectionName: "products"))
                          ..add(FetchCategories()),
                      ),
                      BlocProvider(
                        create: (context) => CreateCategoryBloc(
                          dbService: FirestoreCategoryService(
                              firestore: FirebaseFirestore.instance,
                              collectionName: "categories"),
                        ),
                      )
                    ],
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
          SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ProductBloc(
                      FirestoreProductService(
                          fireStore: FirebaseFirestore.instance,
                          collectionName: "products"),
                      FirestoreInventoryService(
                          fireStore: FirebaseFirestore.instance,
                          collectionName: "inventory"),
                    ),
                    child: CreateProduct(),
                  ),
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.category),
              title: Text("Create Product"),
            ),
          ),
        ],
      ),
    );
  }
}
