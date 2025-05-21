import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/products/cart/cart_bloc.dart';
import 'package:grocery_app/blocs/products/product_detail/product_detail_bloc.dart';
import 'package:grocery_app/widgets/error_widget.dart';
import '../../models/product/product.dart';
import '../../widgets/add_to_cart_button.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  final double _imageHeight = 300.0;
  final double _appBarHeight = kToolbarHeight;
  final GlobalKey _cartButtonKey = GlobalKey();
  bool _isCartButtonVisible = false;
  bool _wasCartButtonVisible = false;
  bool _stickButton = true;

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   setState(() {
    // _scrollOffset = _scrollController.offset;
    // _scrollController.addListener(_checkCartButtonVisibility);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _checkCartButtonVisibility(); // Initial check
    // });
    //   });
    // });
  }

  // void _checkCartButtonVisibility() {
  //   final renderBox = _cartButtonKey.currentContext?.findRenderObject()
  //       as RenderBox?; //target the button with key
  //   if (renderBox != null) {
  //     final buttonPosition = renderBox.localToGlobal(Offset.zero);
  //     final screenHeight = MediaQuery.of(context).size.height;
  //     final buttonHeight = renderBox.size.height;

  //     // Calculate visibility (with 10px threshold)
  //     final isVisible = buttonPosition.dy + buttonHeight > 0 &&
  //         buttonPosition.dy < screenHeight - 10;

  //     setState(() {
  //       print("running state");
  //       _isCartButtonVisible = isVisible;
  //     });

  //     // Trigger events only on state changes
  //     if (_isCartButtonVisible != _wasCartButtonVisible) {
  //       _wasCartButtonVisible = _isCartButtonVisible;

  //       if (_isCartButtonVisible) {
  //         _onCartButtonAppeared();
  //       } else {
  //         _onCartButtonDisappeared();
  //       }
  //     }
  //   }
  // }

  // void _onCartButtonAppeared() {
  //   setState(() {
  //     _stickButton = false;
  //   });
  // }

  // void _onCartButtonDisappeared() {
  //   setState(() {
  //     _stickButton = true;
  //   });
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarOpacity =
        (_scrollOffset / (_imageHeight - _appBarHeight)).clamp(0.0, 1.0);
    final double imageTop = -_scrollOffset * 0.5;
    final double imageScale =
        1.0 - (_scrollOffset / _imageHeight * 0.5).clamp(0.0, 0.5);

    return BlocConsumer<ProductDetailBloc, ProductDetailState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state.error != null) {
          return AppErrorWidget(
              message: "Something went wrong", onRetry: () {});
        }
        if (state.product == null) {
          return AppErrorWidget(message: "No product found", onRetry: () {});
        }
        Product product = state.product!;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: appBarOpacity > 0.7
                ? Colors.white
                : Colors.white.withValues(alpha: appBarOpacity),
            elevation: appBarOpacity > 0.5 ? 2 : 0.0,
            title: Opacity(
              opacity: appBarOpacity,
              child: Text(
                product.name ?? "",
                style: TextStyle(
                    color: appBarOpacity > 0.5 ? Colors.black : Colors.white),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: appBarOpacity > 0.5 ? Colors.black : Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Stack(
            children: [
              CustomScrollView(
                // controller: _scrollController,
                slivers: [
                  //Sliver App Bar
                  SliverAppBar(
                    expandedHeight: _imageHeight,
                    backgroundColor: Colors.white,
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.zoomBackground],
                      background: Transform.translate(
                        offset: Offset(0, imageTop),
                        child: Transform.scale(
                          scale: imageScale,
                          child: Image.network(
                            product.images[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product title and details
                          Text(
                            product.name ?? "",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${product.quantityInBox} ${product.unit}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),

                          // Price information
                          Row(
                            children: [
                              Text(
                                '₹${product.sellingPrice}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              if (product.discount! > 0)
                                Text(
                                  '${product.discount}% OFF',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MRP ₹${product.mrp} (inclusive of all taxes)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${(product.sellingPrice! / (product.quantityInBox! * 100)).toStringAsFixed(1)}/100 g',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),

                          InkWell(
                            onTap: () {
                              context
                                  .read<ProductDetailBloc>()
                                  .add(ShowProductDetails());
                            },
                            child: BlocBuilder<ProductDetailBloc,
                                ProductDetailState>(
                              buildWhen: (previous, current) =>
                                  previous.viewProductDetails !=
                                  current.viewProductDetails,
                              builder: (context, state) {
                                print("hurrat state");
                                print(state.viewProductDetails);
                                return Row(
                                  children: [
                                    Text(
                                      'View product details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Icon(
                                      state.viewProductDetails
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          if (state.viewProductDetails) ...[
                            const SizedBox(height: 16),
                            if (product.summary != null &&
                                product.summary!.isNotEmpty)
                              _buildDetailSection(product),
                            // if (widget.product.keyFeatures != null &&
                            //     widget.product.keyFeatures!.isNotEmpty)
                            //   _buildDetailSection(
                            //       'Key Features', widget.product.keyFeatures!),
                          ],
                          const SizedBox(height: 24),

                          // Explore all products
                          Container(
                            height: 80,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(),
                                  child: Image.network(product.images[0]),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.brand!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const Text("Explore all products",
                                        style: TextStyle(fontSize: 16))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Similar products section
                          const Text(
                            'Similar products',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          _buildSimilarProducts(),
                          const SizedBox(height: 40),

                          // Add to cart button
                          // SizedBox(
                          //   key: _cartButtonKey,
                          //   width: double.infinity,
                          //   child: BlocBuilder<CartBloc, CartState>(
                          //     builder: (context, state) {
                          //       return addToCartButton(
                          //         product,
                          //         context
                          //             .read<CartBloc>()
                          //             .state
                          //             .items[product.id!],
                          //         context,
                          //       );
                          //     },
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ListTile(
                        title: Text("Home Content $index"),
                      );
                    }, childCount: 20),
                  )
                ],
              ),
              _stickButton
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          final productInCart = state.items[product.id!];
                          return addToCartButton(
                              product, productInCart, context);
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Support and Delivery icons row (unchanged)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.support),
                    Text("24/7",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Support")
                  ],
                ),
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delivery_dining_outlined),
                    Text("Fast",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Delivery")
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 10),

        // Highlights section
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100),
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            buildWhen: (previous, current) =>
                previous.showHighlights != current.showHighlights,
            builder: (context, state) {
              return Column(
                children: [
                  // Highlights header
                  ListTile(
                    title: Text("Highlights",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    trailing: IconButton(
                      icon: Icon(state.showHighlights
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                      onPressed: () {
                        context
                            .read<ProductDetailBloc>()
                            .add(ShowProductHighlights());
                      },
                    ),
                  ),

                  // Highlights content (shown when expanded)
                  if (state.showHighlights)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(100), // Fixed width for titles
                          1: FlexColumnWidth(), // Flexible width for content
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.top,
                        children: [
                          // Description row
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  product.summary!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Key Features row
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Key Features",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  product.summary!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Unit row
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Unit",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  product.unit!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 8),

        //Info Section
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100),
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            buildWhen: (previous, current) =>
                previous.showInfo != current.showInfo,
            builder: (context, state) {
              return Column(
                children: [
                  // Highlights header
                  ListTile(
                    title: Text("Info",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    trailing: IconButton(
                      icon: Icon(state.showInfo
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                      onPressed: () {
                        context
                            .read<ProductDetailBloc>()
                            .add(ShowProductInfo());
                      },
                    ),
                  ),

                  // Info (shown when expanded)
                  if (state.showInfo)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(100), // Fixed width for titles
                          1: FlexColumnWidth(), // Flexible width for content
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.top,
                        children: [
                          // Description row
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Shelf Life",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "3 Months",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Return Policy",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "This Item is non-returnable.For a damaged, defective, incorrect or expired item, you can request a replacement within 72 hours of delivery",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Unit row
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Unit",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  product.unit!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Manufacturer's name and Address",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "ITC Limited,37,J.L nehru Road,Kolkata-700071",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Marketed By",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Aashirvaad",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Countrty of Origin",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "India",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarProducts() {
    return Column(
      children: [
        _buildSimilarProductItem('Multigrain Atta', '5 kg'),
        const SizedBox(height: 12),
        _buildSimilarProductItem('Sharbati Atta', '10 kg'),
        const SizedBox(height: 12),
        _buildSimilarProductItem('Wheat Atta', '5 kg'),
      ],
    );
  }

  Widget _buildSimilarProductItem(String name, String weight) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(weight, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
}
