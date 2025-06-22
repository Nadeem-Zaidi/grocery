import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/beauty_cosmetics/bloc/form_bloc.dart';
import 'package:grocery_app/blocs/bloc/new_product/bloc/new_product_bloc.dart';
import 'package:grocery_app/blocs/categories/create_category_bloc/category_create_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/database_service.dart/db_service.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:grocery_app/models/form_config/form_config.dart';
import 'package:grocery_app/pages/category_pages/categories.dart';
import 'package:grocery_app/pages/product_pages/new_product.dart';
import 'package:grocery_app/service_locator/service_locator.dart';
import '../database_service.dart/category/firestore_category_service.dart';
import '../models/category.dart' as cat;
import '../models/product/productt.dart';

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
                            ServiceLocator()
                                .getWithParam<DBService<Productt>, String>(
                                    "products"))
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
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => NewProductBloc(
                          dbService:
                              ServiceLocator().get<DBService<cat.Category>>(),
                        ),
                      ),
                    ],
                    child: NewProduct(),
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
