import 'dart:math';
import 'package:flutter/material.dart';

import '../models/category.dart';

class ShopByStoreTile extends StatefulWidget {
  final Category category;
  const ShopByStoreTile({super.key, required this.category});

  @override
  State<ShopByStoreTile> createState() => _ShopByStoreTileState();
}

class _ShopByStoreTileState extends State<ShopByStoreTile> {
  static final List<Color> colors = [
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
    Colors.teal.shade200,
  ];

  late final Color randomColor;

  @override
  void initState() {
    super.initState();
    randomColor = colors[Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: randomColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: widget.category.url != null && widget.category.url!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                height: 30,
                widget.category.url!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
            )
          : Container(color: Colors.grey),
    );
  }
}
