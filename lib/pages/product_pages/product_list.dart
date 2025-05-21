import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/widgets/build_product_grid.dart';
import 'package:grocery_app/widgets/category_list.dart';
import 'package:grocery_app/widgets/empty_state.dart';
import 'package:grocery_app/widgets/error_widget.dart';

import '../../models/category.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    String appBarName =
        context.read<FetchCategoryBloc>().state.categoryName ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarName),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
          IconButton(
            onPressed: () => _goToCart(context),
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Cart',
          ),
        ],
      ),
      body: Row(
        children: [
          BlocBuilder<FetchCategoryBloc, FetchCategoryState>(
            builder: (context, state) {
              if (state.childrenCategories.isNotEmpty) {
                List<Category> childrenCat = state.childrenCategories;
                return SizedBox(
                  width: 50,
                  child: CategoryList(categories: childrenCat),
                  // Give it a reasonable width
                );
              }
              return Container(); // Maintain consistent width
            },
          ),
          // Vertical divider
          const VerticalDivider(thickness: 1, width: 1),
          // Product Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<FetchCategoryBloc, FetchCategoryState>(
                  builder: (context, state) {
                if (state.error != null) {
                  return Center(
                    child: AppErrorWidget(
                        message: "Some thing went wrong in fetching products",
                        onRetry: () {}),
                  );
                }
                if (state.products.isEmpty) {
                  return EmptyStateWidget(
                      title: "No Product Found",
                      subtitle: "",
                      icon: Icons.category_outlined);
                }
                return BuildProductGrid(products: state.products);
              }),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => _goToCart(context),
      //   label: const Text("View Cart"),
      //   icon: const Icon(Icons.shopping_cart),
      // ),
    );
  }

  void _goToCart(BuildContext context) {
    // Navigation to cart screen would go here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cart screen would open here")),
    );
  }
}
