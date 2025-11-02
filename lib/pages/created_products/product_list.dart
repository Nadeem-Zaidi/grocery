import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';

import '../../blocs/form_bloc/form_bloc.dart';
import '../../database_service.dart/db_service.dart';
import '../../forms/form.dart';
import '../../models/form_config/form_config.dart';
import '../../models/product/productt.dart';
import '../../service_locator/service_locator.dart';

class CreatedProductList extends StatefulWidget {
  const CreatedProductList({super.key});

  @override
  State<CreatedProductList> createState() => _CreatedProductListState();
}

class _CreatedProductListState extends State<CreatedProductList> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchCategoryBloc, FetchCategoryState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Created Products'),
            backgroundColor: Colors.green.shade700,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              Productt product = state.products[index];
              return Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                            itemCount: product.variations.length,
                            itemBuilder: (context, vIndex) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                child: Center(
                                  child: Text(
                                    product.variations[vIndex].unitSize,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () {
                        final dbService = ServiceLocator()
                            .getWithParam<DBService<FormConfig>, String>(
                                "categories/DVfxexcGmZxOkmULfEOZ/variations");
                        final productService = ServiceLocator()
                            .getWithParam<DBService<Productt>, String>(
                                "products");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (newContext) => BlocProvider(
                              create: (context) => FormBloc(
                                  forEntity: "newvariation",
                                  dbService: dbService,
                                  productService: productService)
                                ..add(SetFormCategory(
                                    category: state.selectedCategory!,
                                    product: product)),
                              child: CosmeticForm(),
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          drawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const DrawerHeader(
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...state.categories.map((category) {
                  return ListTile(
                    title: Text(category.name ?? ''),
                    onTap: () {
                      context
                          .read<FetchCategoryBloc>()
                          .add(SelectProductCategory(category));
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
