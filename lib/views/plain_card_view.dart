import 'dart:io';

import 'package:flutter/material.dart';

class PlainCardView extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final Color? backgroundColor;
  final File? imageFile;
  final VoidCallback? onSelectImage;
  final VoidCallback? onRemoveImage;
  final VoidCallback? onChangebackGround;
  final void Function(String)? onSelectFromCloud;
  final double cardHeight;
  final double cardWidth;

  const PlainCardView({
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
    required this.onChangebackGround,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor,
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
            Positioned(
              right: cardWidth * 0.01,
              top: cardHeight * 0.01,
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
