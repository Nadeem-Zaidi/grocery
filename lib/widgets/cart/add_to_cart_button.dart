import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/widgets/cart/cart_action_button.dart';
import 'package:grocery_app/widgets/cart/cart_action_content.dart';
import 'package:grocery_app/widgets/cart/cart_increment_decrement.dart';

import '../../blocs/products/cart/cart_bloc.dart';
import '../../models/cart/cart_model.dart';
import '../../models/product/product.dart';
import '../../models/product/productt.dart';

class AddToCartInProductDescription extends StatefulWidget {
  final Variation variation;
  final CartItem? cartItem;
  final CartActionContent cartAction;

  const AddToCartInProductDescription(
      {super.key,
      required this.variation,
      required this.cartItem,
      required this.cartAction});

  @override
  State<AddToCartInProductDescription> createState() =>
      _AddToCartInProductDescriptionState();
}

class _AddToCartInProductDescriptionState
    extends State<AddToCartInProductDescription> {
  @override
  Widget build(BuildContext context) {
    return widget.cartItem != null
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.variation.unitSize} ${widget.variation.unitOfMeasure}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.currency_rupee,
                          size: 18,
                        ),
                        Text(
                          widget.variation.sellingPrice!.round().toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // MRP with strike-through
                        Row(
                          children: [
                            Text(
                              "MRP ",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              widget.variation.mrp.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // Quantity controls
                Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: widget.cartAction),
              ],
            ),
          )
        : ElevatedButton(
            onPressed: () {
              context.read<CartBloc>().add(
                    CartItemAdded(variation: widget.variation),
                  );
            },
            child: Text("Add To Cart"));
  }
}
