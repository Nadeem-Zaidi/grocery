import 'package:flutter/material.dart';

import '../../models/product/productt.dart';

class VariationCard extends StatefulWidget {
  final Variation variation;
  const VariationCard({super.key, required this.variation});

  @override
  State<VariationCard> createState() => _VariationCardState();
}

class _VariationCardState extends State<VariationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            child: Text(
              "Unit",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [Text("Selling Price"), Text("Mrp"), Text("Discount")],
          )
        ],
      ),
    );
  }
}
