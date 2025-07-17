import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/blocs/products/cart/cart_bloc.dart';
import 'package:grocery_app/blocs/products/product_detail/product_detail_bloc.dart';
import 'package:grocery_app/extensions/capitalize_first.dart';
import 'package:grocery_app/widgets/cart/cart_action_button.dart';
import 'package:grocery_app/widgets/error_widget.dart';
import 'package:grocery_app/widgets/image_slider.dart';
import '../../models/product/productt.dart';
import '../../widgets/cart/add_to_cart_button.dart';
import '../../widgets/products/variation_discount_box.dart';

class ProductDetailPage extends StatefulWidget {
  Productt product;
  Variation variation;
  ProductDetailPage(
      {super.key, required this.product, required this.variation});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ScrollController _scrollController = ScrollController();

  double _scrollOffset = 0.0;
  final double _imageHeight = 300.0;
  final double _appBarHeight = kToolbarHeight;
  final GlobalKey _cartButtonKey = GlobalKey();
  // bool _isCartButtonVisible = false;
  // bool _wasCartButtonVisible = false;
  // bool _stickButton = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (mounted) {
        // Check if widget is still mounted
        final newOffset = _scrollController.offset;
        if ((newOffset - _scrollOffset).abs() > 2.0) {
          // Only update if significant change
          setState(() {
            _scrollOffset = newOffset;
          });
        }
      }
    });
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
    Productt product = widget.product;
    Variation variation = widget.variation;

    final double appBarOpacity =
        (_scrollOffset / (_imageHeight - _appBarHeight)).clamp(0.0, 1.0);
    final double imageTop = -_scrollOffset * 0.5;
    final double imageScale =
        1.0 - (_scrollOffset / _imageHeight * 0.5).clamp(0.0, 0.5);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: appBarOpacity > 0.7
            ? Theme.of(context).primaryColor
            : Colors.white.withValues(alpha: appBarOpacity),
        elevation: appBarOpacity > 0.5 ? 2 : 0.0,
        title: Opacity(
          opacity: appBarOpacity,
          child: Text(
            product.name ?? "",
            style: TextStyle(
                color: appBarOpacity > 0.7 ? Colors.white : Colors.black),
          ),
        ),
        leading: Container(
          margin: EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).primaryColor),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 18,
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                //Sliver App Bar
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: _imageHeight,
                  backgroundColor: Colors.white,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.zoomBackground],
                    background: Transform.translate(
                      offset: Offset(0, imageTop),
                      child: ImageSlider(imageUrls: variation.images),
                      // child: Transform.scale(
                      //     scale: imageScale,
                      //     child: ImageSlider(imageUrls: imageTest)),
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
                          '${variation.unitSize} ${variation.unitOfMeasure}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),

                        // Price information
                        Row(
                          children: [
                            Text(
                              '₹${variation.sellingPrice}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            if (variation.discount > 0)
                              Text(
                                '${variation.discount}% OFF',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'MRP ₹${variation.mrp} (inclusive of all taxes)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        const Text("Select Unit",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        product.variations.length > 1
                            ? SizedBox(
                                height:
                                    150, // constrain height for vertical list
                                child: ListView.builder(
                                  scrollDirection:
                                      Axis.horizontal, // horizontal scroll
                                  itemCount: product.variations.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: DiscountBox(
                                        variation: product.variations[index],
                                        selectedVariationId: variation.id!,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const SizedBox(),

                        const SizedBox(height: 24),

                        InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Text(
                                  'View product details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(
                                  Icons.expand_more,
                                ),
                              ],
                            )),

                        const SizedBox(height: 16),

                        _buildDetailSection(product),
                        // if (widget.product.keyFeatures != null &&
                        //     widget.product.keyFeatures!.isNotEmpty)
                        //   _buildDetailSection(
                        //       'Key Features', widget.product.keyFeatures!),

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
                                child: Image.network(variation.images[0]),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.brand,
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
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CartActionButton(
              variation: variation,
              withDetail: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailSection(Productt product) {
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
          child: Column(
            children: [
              // Highlights header
              ListTile(
                title: Text("Highlights",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {},
                ),
              ),

              // Highlights content (shown when expanded)

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(0.4), // slightly less for title
                    1: FlexColumnWidth(0.6),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: [
                    for (var highlight in product.highLights.entries)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              highlight.key.toLowerCase().capitalizeFirst(),
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
                              highlight.value.toString().capitalizeFirst(),
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
          ),
        ),
        SizedBox(height: 8),

        //Info Section
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with toggle
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                title: Text(
                  "Info",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_drop_up),
                  onPressed: () {
                    context.read<ProductDetailBloc>().add(ShowProductInfo());
                  },
                ),
              ),

              // Expanded content

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(0.4), // slightly less for title
                    1: FlexColumnWidth(0.6), // slightly more for value
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    for (var entry in product.info.entries)
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 8.0,
                            ),
                            child: Text(
                              entry.key.toString().capitalizeFirst(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 8.0,
                            ),
                            child: Text(
                              entry.value.toString().capitalizeFirst(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
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
