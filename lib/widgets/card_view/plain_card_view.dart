import 'dart:io';

import 'package:flutter/material.dart';

class PromoCardView extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final Color? backgroundColor;
  final File? imageFile;
  final VoidCallback? onSelectImage;
  final VoidCallback? onRemoveImage;
  final void Function(String)? onSelectFromCloud;
  final double cardHeight;
  final double cardWidth;

  const PromoCardView({
    super.key,
    this.title,
    this.imageUrl,
    this.backgroundColor,
    this.imageFile,
    this.onSelectImage,
    this.onRemoveImage,
    this.onSelectFromCloud,
    required this.cardHeight,
    required this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor,
        // gradient: LinearGradient(
        //   colors: [backgroundColor ?? Colors.grey.shade400, Colors.white],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(theme),
            if (title != null && title!.isNotEmpty)
              Positioned(
                left: 10,
                bottom: 10,
                child: Text(
                  title!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              right: 1,
              top: 1,
              child: GestureDetector(
                onTap: onRemoveImage,
                child: Icon(
                  Icons.remove_circle,
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    if (imageFile != null) {
      return Image.file(imageFile!, fit: BoxFit.cover);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onSelectImage,
            child: Icon(
              Icons.image_outlined,
              size: cardHeight * 0.4,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          GestureDetector(
            onTap: () => onSelectFromCloud?.call(''),
            child: Icon(
              Icons.link_rounded,
              size: cardHeight * 0.4,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      );
    }
  }
}
