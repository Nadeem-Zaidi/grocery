import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/change_variation/bloc/change_variation_bloc.dart';
import '../../models/product/productt.dart';
import '../cart/product_in_cart.dart';
import 'show_modal_bottom_sheet.dart';

class VariationInProductCard extends StatefulWidget {
  final Variation variation;
  final Productt product;
  final Widget Function(BuildContext context, Variation variation)?
      buildCartAction;

  const VariationInProductCard({
    super.key,
    required this.product,
    required this.variation,
    required this.buildCartAction,
  });

  @override
  State<VariationInProductCard> createState() => _VariationInProductCardState();
}

class _VariationInProductCardState extends State<VariationInProductCard> {
  late Productt product;
  late Variation v;
  late String variationId;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    v = product.variations[0];
    variationId = v.id!;
    context
        .read<ChangeVariationBloc>()
        .add(ChangeVariation(variationId: variationId));
  }

  @override
  Widget build(BuildContext context) {
    final variation = widget.variation;
    print(variation.images);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return SizedBox(
          height: 300, // Fixed overall card height, you can adjust
          child: Card(
            margin: EdgeInsets.all(screenWidth * 0.012),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image and cart action
                  SizedBox(
                    height: 120,
                    child: Stack(
                      children: [
                        variation.images.isNotEmpty
                            ? Image.network(
                                variation.images[0],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 120,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image),
                              )
                            : Container(
                                width: double.infinity,
                                height: 120,
                                color: Colors.grey.shade300,
                              ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: SizedBox(
                            height: 30,
                            width: 80,
                            child: product.variations.length < 2 &&
                                    widget.buildCartAction != null
                                ? widget.buildCartAction!(context, variation)
                                : GestureDetector(
                                    onTap: () {
                                      showModalBottom(
                                        context,
                                        product,
                                        widget.buildCartAction,
                                        () {},
                                      );
                                    },
                                    child: ProductInCart(
                                      productId: product.id!,
                                      options:
                                          "${product.variations.length} Options",
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Unit and product type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _tagBox(
                        context,
                        "${variation.unitSize}${variation.unitOfMeasure}",
                      ),
                      _tagBox(context, "Wheat Atta"),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Product name
                  Text(
                    variation.name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Delivery time
                  Row(
                    children: [
                      Icon(
                        Icons.timelapse,
                        size: 14,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      const Text("18 MINS", style: TextStyle(fontSize: 9)),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Discount
                  Row(
                    children: [
                      Text(
                        "${variation.discount} OFF",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Selling price and MRP
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee, size: 16),
                      Text(
                        variation.sellingPrice.round().toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text("MRP", style: TextStyle(fontSize: 9)),
                      const SizedBox(width: 4),
                      Text(
                        variation.mrp.toString(),
                        style: const TextStyle(
                          fontSize: 9,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Variation bottom dropdown
                  InkWell(
                    onTap: () {
                      showModalBottom(
                          context, product, widget.buildCartAction, () {});
                    },
                    child: Row(
                      children: [
                        Text(
                          "${variation.unitSize} ${variation.unitOfMeasure}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper widget for unit/type tags
  Widget _tagBox(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
        textAlign: TextAlign.center,
      ),
    );
  }
}
