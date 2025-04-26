import 'package:flutter/material.dart';

import '../models/category.dart';

class DashboardCategory extends StatefulWidget {
  final Category category;
  const DashboardCategory({super.key, required this.category});

  @override
  State<DashboardCategory> createState() => _DashboardCategoryState();
}

class _DashboardCategoryState extends State<DashboardCategory> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.2,
              child:
                  widget.category.url != null && widget.category.url!.isNotEmpty
                      ? Image.network(
                          widget.category.url!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
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
