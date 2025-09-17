import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/bloc/new_product/bloc/new_product_bloc.dart';
import 'package:grocery_app/blocs/categories/create_category_bloc/category_create_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/blocs/section/dashboard_bloc/dashboard_bloc.dart';
import 'package:grocery_app/database_service.dart/db_service.dart';
import 'package:grocery_app/pages/category_pages/categories.dart';
import 'package:grocery_app/pages/created_products/product_list.dart';
import 'package:grocery_app/widgets/templates/page_builder.dart';
import 'package:grocery_app/pages/product_pages/new_product.dart';
import 'package:grocery_app/service_locator/service_locator.dart';
import '../models/category.dart' as cat;
import '../models/product/productt.dart';

class CategoryDrawer extends StatefulWidget {
  const CategoryDrawer({super.key});

  @override
  State<CategoryDrawer> createState() => _CategoryDrawerState();
}

class _CategoryDrawerState extends State<CategoryDrawer> {
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
                            ServiceLocator().get<DBService<cat.Category>>(),
                            ServiceLocator()
                                .getWithParam<DBService<Productt>, String>(
                                    "products"))
                          ..add(FetchCategories()),
                      ),
                      BlocProvider(
                        create: (context) => CreateCategoryBloc(
                          dbService:
                              ServiceLocator().get<DBService<cat.Category>>(),
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
                        create: (context) => FetchCategoryBloc(
                            ServiceLocator().get<DBService<cat.Category>>(),
                            ServiceLocator().get<DBService<Productt>>())
                          ..add(FetchCategories()),
                      )
                    ],
                    child: CreatedProductList(),
                  ),
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.category),
              title: Text("Product List"),
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
                        create: (context) => DashboardBloc(),
                      ),
                    ],
                    child: PageBuilder(),
                  ),
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.category),
              title: Text("Product List"),
            ),
          ),
        ],
      ),
    );
  }
}
