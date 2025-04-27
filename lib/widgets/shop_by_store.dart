import 'package:flutter/material.dart';

import '../models/category.dart';

class ShopByStore extends StatefulWidget {
  final Category category;
  const ShopByStore({super.key, required this.category});

  @override
  State<ShopByStore> createState() => _ShopByStoreState();
}

class _ShopByStoreState extends State<ShopByStore> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.2,
              child:
                  widget.category.url != null && widget.category.url!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.category.url!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          ),
                        )
                      : Container(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.category.name ?? 'Unnamed',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
