import 'package:flutter/material.dart';

import '../../models/product/productt.dart';

class CreatedProductDetail extends StatefulWidget {
  final List<Variation> variations;
  const CreatedProductDetail({super.key, required this.variations});

  @override
  State<CreatedProductDetail> createState() => _CreatedProductDetailState();
}

class _CreatedProductDetailState extends State<CreatedProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: widget.variations.length,
          itemBuilder: (context, index) {
            return Text("hello");
          },
        ),
      ],
    );
  }
}
