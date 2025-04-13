import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/products/cart/cart_bloc.dart';
import '../../models/product/product.dart';
import '../../widgets/add_to_cart_button.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  final double _imageHeight = 300.0;
  final double _appBarHeight = kToolbarHeight;
  bool _showDetails = false; // Track whether details are expanded

  final GlobalKey _cartButtonKey = GlobalKey();
  bool _isCartButtonVisible = false;
  bool _wasCartButtonVisible = false;
  bool _stickButton = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
        _scrollController.addListener(_checkCartButtonVisibility);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkCartButtonVisibility(); // Initial check
        });
      });
    });
  }

  void _checkCartButtonVisibility() {
    final renderBox = _cartButtonKey.currentContext?.findRenderObject()
        as RenderBox?; //target the button with key
    if (renderBox != null) {
      final buttonPosition = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      final buttonHeight = renderBox.size.height;

      // Calculate visibility (with 10px threshold)
      final isVisible = buttonPosition.dy + buttonHeight > 0 &&
          buttonPosition.dy < screenHeight - 10;

      setState(() {
        _isCartButtonVisible = isVisible;
      });

      // Trigger events only on state changes
      if (_isCartButtonVisible != _wasCartButtonVisible) {
        _wasCartButtonVisible = _isCartButtonVisible;

        if (_isCartButtonVisible) {
          _onCartButtonAppeared();
        } else {
          _onCartButtonDisappeared();
        }
      }
    }
  }

  void _onCartButtonAppeared() {
    setState(() {
      _stickButton = false;
    });
  }

  void _onCartButtonDisappeared() {
    print('Cart button left the screen');
    // Trigger your events here
    setState(() {
      _stickButton = true;
    });
  }

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
            widget.product.name ?? "",
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
            controller: _scrollController,
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
                        widget.product.images[0],
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
                        widget.product.name ?? "",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.product.quantityInBox} ${widget.product.unit}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      // Price information
                      Row(
                        children: [
                          Text(
                            '₹${widget.product.sellingPrice}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          if (widget.product.discount! > 0)
                            Text(
                              '${widget.product.discount}% OFF',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'MRP ₹${widget.product.mrp} (inclusive of all taxes)',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${(widget.product.sellingPrice! / (widget.product.quantityInBox! * 100)).toStringAsFixed(1)}/100 g',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),

                      // Expandable product details section
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showDetails = !_showDetails;
                          });
                        },
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
                              _showDetails
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                          ],
                        ),
                      ),
                      if (_showDetails) ...[
                        const SizedBox(height: 16),
                        if (widget.product.summary != null &&
                            widget.product.summary!.isNotEmpty)
                          _buildDetailSection(
                              'Description', widget.product.summary!),
                        if (widget.product.keyFeatures != null &&
                            widget.product.keyFeatures!.isNotEmpty)
                          _buildDetailSection(
                              'Key Features', widget.product.keyFeatures!),
                      ],
                      const SizedBox(height: 24),

                      // Explore all products
                      const Text(
                        'Aashirvaad\nExplore all products',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                      SizedBox(
                        key: _cartButtonKey,
                        width: double.infinity,
                        child: BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            return addToCartButton(
                              widget.product,
                              context
                                  .read<CartBloc>()
                                  .state
                                  .items[widget.product.id!],
                              context,
                            );
                          },
                        ),
                      )
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
                      final productInCart = state.items[widget.product.id!];
                      return addToCartButton(
                          widget.product, productInCart, context);
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
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
