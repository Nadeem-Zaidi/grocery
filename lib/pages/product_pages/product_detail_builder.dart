import 'package:flutter/material.dart';

class ProductDetailBuilder extends StatefulWidget {
  Widget Function(List<String>) imageCrousal;
  Widget Function(Map<String, dynamic>) highLightSection;
  Widget Function(Map<String, dynamic>) infoSection;
  ProductDetailBuilder(
      {super.key,
      required this.imageCrousal,
      required this.highLightSection,
      required this.infoSection});

  @override
  State<ProductDetailBuilder> createState() => _ProductDetailBuilderState();
}

class _ProductDetailBuilderState extends State<ProductDetailBuilder> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
