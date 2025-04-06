import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/blocs/products/fetch_product/fetch_product_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/category.dart';
import '../../models/product/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    print(context.read<FetchProductBloc>().state);
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
                List<Category> childrenCat = state.childrenCategories;
                return SizedBox(
                  width: 80, // Give it a reasonable width
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: childrenCat.length,
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedCategoryIndex == index;
                      return InkWell(
                        onTap: () {
                          setState(
                            () {
                              _selectedCategoryIndex = index;
                              // Here you would typically filter products by category
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1)
                                : Colors.transparent,
                            border: isSelected
                                ? Border(
                                    left: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 3,
                                    ),
                                  )
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Category Image
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: isSelected
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                ),
                                child: childrenCat[index].url != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          childrenCat[index].url!,
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.category,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            );
                                          },
                                        ),
                                      )
                                    : Icon(
                                        Icons.category,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                              ),
                              const SizedBox(height: 8),
                              // Category Name
                              Text(
                                childrenCat[index].name ?? "",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
              child: _buildProductGrid(context),
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

  Widget _buildProductGrid(BuildContext context) {
    return BlocBuilder<FetchProductBloc, FetchProductState>(
        builder: (context, state) {
      if (state.products.isNotEmpty) {
        List<Product> products = state.products;
        int productCount = products.length;
        return GridView.builder(
            itemCount: productCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.4),
            itemBuilder: (context, index) {
              return SizedBox(
                height: 200,
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: Card(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 0.8,
                              child: products[index].images[0] != null
                                  ? Image.network(
                                      products[index].images[0],
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                    )
                                  : Container(color: Colors.grey),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 30,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  "ADD",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    " 5kg ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "Wheat Atta",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ashirvad Shudh Chakki Atta(100% Atta 0% Wheat)(5kg)",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timelapse,
                              size: 15,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.7),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("18 MINS")
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "9%",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "OFF",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.currency_rupee),
                            Text(
                              "200",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(width: 7),
                            Row(
                              children: [
                                Text(
                                  "MRP",
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  "250",
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      }

      return Container();
    });
  }

  void _goToCart(BuildContext context) {
    // Navigation to cart screen would go here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cart screen would open here")),
    );
  }
}
