import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/products/cart/cart_bloc.dart';
import 'package:grocery_app/widgets/cart/cart_increment_decrement.dart';

import 'add_button.dart';

class ProductInCart extends StatefulWidget {
  final String productId;
  final String options;
  const ProductInCart(
      {super.key, required this.productId, required this.options});

  @override
  State<ProductInCart> createState() => _ParentInCartState();
}

class _ParentInCartState extends State<ProductInCart> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.quantityPerProductId.containsKey(widget.productId) &&
            state.quantityPerProductId[widget.productId]! > 0) {
          return Container(
            decoration: BoxDecoration(color: Colors.green),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.remove, color: Colors.white, size: 18),
                Text(
                  "${state.quantityPerProductId[widget.productId]!}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.add, color: Colors.white, size: 18)
              ],
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.green),
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Text(
                    "ADD",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Colors.green.shade100,
                  child: Text(widget.options,
                      style:
                          TextStyle(fontSize: 9, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
