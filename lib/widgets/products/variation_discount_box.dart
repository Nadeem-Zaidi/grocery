import 'package:flutter/material.dart';

import '../../models/product/productt.dart';

class DiscountBox extends StatefulWidget {
  Variation variation;
  String selectedVariationId;

  DiscountBox(
      {super.key, required this.variation, required this.selectedVariationId});

  @override
  State<DiscountBox> createState() => _DiscountBoxState();
}

class _DiscountBoxState extends State<DiscountBox> {
  @override
  Widget build(BuildContext context) {
    Variation variation = widget.variation;
    return Center(
      child: Container(
        width: 125,
        height: 100,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: variation.id == widget.selectedVariationId
              ? const Color(0xFFE8F5E9)
              : Colors.white, // Light greenish background
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
                  variation.unitSize,
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
                      '${variation.unitSize} ${variation.unitOfMeasure}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Text(
                          '${variation.sellingPrice}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              'MRP',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              '${variation.mrp}',
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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
                  '${variation.discount.toStringAsFixed(0)}% OFF',
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
