import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';

import '../../models/category.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int _selectedCategoryIndex = 0;

  final List<Product> _products = [
    Product(
      name: "Aashirvaad 10 kg",
      price: 450,
      imageUrl: "https://via.placeholder.com/300?text=Aashirvaad+10kg",
    ),
    Product(
      name: "Aashirvaad 5 kg",
      price: 250,
      imageUrl: "https://via.placeholder.com/300?text=Aashirvaad+5kg",
    ),
    Product(
      name: "Multigrain Atta 5 kg",
      price: 300,
      imageUrl: "https://via.placeholder.com/300?text=Multigrain+5kg",
    ),
    Product(
      name: "Multigrain Atta 1 kg",
      price: 70,
      imageUrl: "https://via.placeholder.com/300?text=Multigrain+1kg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atta, Rice & Dal"),
        actions: [
          IconButton(
            onPressed: () => _showSearch(context),
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
          // Category Navigation Rail (more modern than a simple list)
          // In your _ProductListState class, replace the BlocBuilder section with this:

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
              return const SizedBox(width: 80); // Maintain consistent width
            },
          ),
          // Vertical divider
          const VerticalDivider(thickness: 1, width: 1),
          // Product Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildProductGrid(),
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

  Widget _buildProductGrid() {
    if (_products.isEmpty) {
      return const Center(child: Text("No products available"));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Container(child: _buildProductCard(product));
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showProductDetails(product),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Aspect Ratio
              // AspectRatio(
              //   aspectRatio: 1,
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(8),
              //     child: Image.network(
              //       product.imageUrl,
              //       fit: BoxFit.cover,
              //       errorBuilder: (context, error, stackTrace) =>
              //           const Icon(Icons.image_not_supported),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 15),
              // Product Name
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Product Price
              Text(
                "₹${product.price}",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () => _addToCart(product),
                  child: const Text("ADD TO CART"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: ProductSearchDelegate(_products),
    );
  }

  void _showProductDetails(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ProductDetailsSheet(product: product);
      },
    );
  }

  void _addToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Added ${product.name} to cart"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {},
        ),
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

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

// Search Delegate
class ProductSearchDelegate extends SearchDelegate {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = query.isEmpty
        ? products
        : products
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          leading: Image.network(product.imageUrl,
              width: 50, height: 50, fit: BoxFit.cover),
          title: Text(product.name),
          subtitle: Text("₹${product.price}"),
          onTap: () {
            close(context, product);
          },
        );
      },
    );
  }
}

// Product Details Sheet
class ProductDetailsSheet extends StatelessWidget {
  final Product product;

  const ProductDetailsSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}
