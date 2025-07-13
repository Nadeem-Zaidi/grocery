import 'package:flutter/material.dart';

class DiscountBox extends StatefulWidget {
  String unitSize;
  double discount;
  double mrp;
  double sellingPrice;

  DiscountBox({
    super.key,
    required this.unitSize,
    required this.discount,
    required this.mrp,
    required this.sellingPrice,
  });

  @override
  State<DiscountBox> createState() => _DiscountBoxState();
}

class _DiscountBoxState extends State<DiscountBox> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 125,
        height: 125,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9), // Light greenish background
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // To push down content below the badge
                Text(
                  widget.unitSize,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${widget.sellingPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'MRP ₹${widget.mrp.toStringAsFixed(2)}',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${(widget.sellingPrice / 100).toStringAsFixed(2)}/100 g',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            // Discount Badge
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFFBBDEFB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  '${widget.discount.toStringAsFixed(0)}% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
