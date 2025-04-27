import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/blocs/products/fetch_product/fetch_product_bloc.dart';
import 'package:grocery_app/pages/product_pages/product_detail.dart';
import 'package:grocery_app/widgets/add_button.dart';
import 'package:grocery_app/widgets/build_product_grid.dart';
import 'package:grocery_app/widgets/cart_increment_decrement.dart';
import 'package:grocery_app/widgets/category_list.dart';

import '../../blocs/products/cart/cart_bloc.dart';
import '../../models/category.dart';
import '../../models/product/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int _selectedCategoryIndex = 0;

  // @override
  // void initState() {
  //   var catState = context.read<FetchCategoryBloc>().state;
  //   print("hurray category string is here ");
  //   // print(catState.childrenCategories[0].path);
  //   print("hurray category string");
  //   context
  //       .read<FetchProductBloc>()
  //       .add(FetchProductWhere(catState.childrenCategories[0].name!));
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    var catState = context.watch<FetchCategoryBloc>().state;

    if (catState.childrenCategories.isNotEmpty) {
      context.read<FetchProductBloc>().add(FetchProductWhere(
          catState.childrenCategories[_selectedCategoryIndex].name!));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("I am running");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atta, Rice & Dal"),
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
                print("is this running");
                List<Category> childrenCat = state.childrenCategories;
                return SizedBox(
                  width: 60,
                  child: CategoryList(categories: childrenCat),
                  // Give it a reasonable width
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              ); // Maintain consistent width
            },
          ),
          // Vertical divider
          const VerticalDivider(thickness: 1, width: 1),
          // Product Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<FetchProductBloc, FetchProductState>(
                  builder: (context, state) {
                if (state.products.isNotEmpty) {
                  return BuildProductGrid(products: state.products);
                }
                return Container();
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToCart(context),
        label: const Text("View Cart"),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }

  void _goToCart(BuildContext context) {
    // Navigation to cart screen would go here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cart screen would open here")),
    );
  }
}
