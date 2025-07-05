import 'package:flutter/material.dart';

class CartIncrementDecrement extends StatefulWidget {
  final String productId;
  final int quantity;
  final double? height;
  final double? width;
  final Function onAdd;
  final Function onRemove;

  const CartIncrementDecrement({
    super.key,
    required this.productId,
    required this.quantity,
    this.height,
    this.width,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<CartIncrementDecrement> createState() => _CartIncrementDecrementState();
}

class _CartIncrementDecrementState extends State<CartIncrementDecrement> {
  @override
  Widget build(BuildContext context) {
    int quantity = widget.quantity;
    return Container(
      width: widget.width,
      height: widget.height ?? 35,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDecrementButton(context),
          Text(
            quantity.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          _buildIncrementButton(context)
        ],
      ),
    );
  }

  Widget _buildDecrementButton(BuildContext context) {
    return InkWell(
      onTap: () => _removeItem(context),
      child: Icon(Icons.remove, color: Colors.white, size: 18),
    );
  }

  Widget _buildIncrementButton(BuildContext context) {
    return InkWell(
      onTap: () => _addItem(context),
      child: Icon(Icons.add, color: Colors.white, size: 18),
    );
  }

  void _addItem(BuildContext context) {
    widget.onAdd();
  }

  void _removeItem(BuildContext context) {
    widget.onRemove();
  }
}
