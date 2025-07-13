import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/beauty_cosmetics/bloc/form_bloc.dart';
import 'package:grocery_app/blocs/bloc/new_product/bloc/new_product_bloc.dart';
import 'package:grocery_app/database_service.dart/db_service.dart';
import 'package:grocery_app/forms/form.dart';
import 'package:grocery_app/models/form_config/form_config.dart';
import 'package:grocery_app/models/product/productt.dart';
import 'package:grocery_app/service_locator/service_locator.dart';

import '../../service_locator/service_locator_func.dart';
import 'select_category_for_new_product.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Product", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white, // White background for AppBar
        iconTheme: const IconThemeData(
            color: Colors.black), // Black color for hamburger icon
        elevation: 1, // subtle shadow if you want
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // better spacing
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                // better text alignment
                children: [
                  Text(
                    "Select Category To Create Product",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BlocBuilder<NewProductBloc, NewProductState>(
                        builder: (context, state) {
                          return TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withAlpha(40),
                              hintText: state.category == null
                                  ? "Select Category"
                                  : state.category!.path.toString(),
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              suffixIcon: state.category == null
                                  ? GestureDetector(
                                      onTap: () {
                                        final newProductBloc =
                                            BlocProvider.of<NewProductBloc>(
                                                context);

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (newContext) =>
                                                BlocProvider.value(
                                              // Provide the existing bloc instance to the new route.
                                              value: newProductBloc,
                                              child:
                                                  const SelectCategoryNewProduct(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.search,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        final dbService = ServiceLocator()
                                            .getWithParam<DBService<FormConfig>,
                                                    String>(
                                                "categories/${state.category?.id}/attributes");
                                        final productService = ServiceLocator()
                                            .getWithParam<DBService<Productt>,
                                                String>("products");
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (newContext) =>
                                                BlocProvider(
                                              create: (context) => FormBloc(
                                                  forEntity: "newproduct",
                                                  dbService: dbService,
                                                  productService:
                                                      productService)
                                                ..add(SetFormCategory(
                                                    category: state.category!)),
                                              child: CosmeticForm(),
                                            ),
                                          ),
                                        );
                                        // Handle search tap here
                                      },
                                      child: const Icon(
                                        Icons.arrow_right,
                                      ),
                                    ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              title: Text('Item 1'),
            ),
          ],
        ),
      ),
    );
  }
}
