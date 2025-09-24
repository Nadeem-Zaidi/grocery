import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/card/customcard/customcard_bloc.dart';

class PromoCard extends StatefulWidget {
  final String? title;
  final String? imageUrl;
  final String? hexColor;

  const PromoCard({super.key, this.title, this.imageUrl, this.hexColor});

  @override
  State<PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<PromoCard> {
  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'ff$hex'; // assume fully opaque
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImageUrl =
        widget.imageUrl != null && widget.imageUrl!.trim().isNotEmpty;

    return BlocBuilder<CustomCardBloc, CustomCardState>(
      builder: (context, state) {
        return Container(
          width: 120,
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                hexToColor(widget.hexColor ?? "#FF9E9E9E"),
                theme.colorScheme.surfaceVariant.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
              children: [
                Positioned(
                  left: 10,
                  right: 8,
                  top: 10,
                  child: SizedBox(
                    width: double.infinity,
                    height: 20,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter title",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                      onChanged: (value) {
                        context.read<CustomCardBloc>().add(
                              SetTitle(title: value.toString()),
                            );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 120,
                    width: 80,
                    child:
                        _buildImageContent(context, state, hasImageUrl, theme),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContent(
    BuildContext context,
    CustomCardState state,
    bool hasImageUrl,
    ThemeData theme,
  ) {
    if (state.imageFile != null) {
      // Show picked image (local file)
      return Image.file(
        File(state.imageFile!.path),
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported_outlined,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      );
    } else if (hasImageUrl) {
      // Show network image
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        height: 100,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported_outlined,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      );
    } else {
      // Show placeholder
      return GestureDetector(
        onTap: () {
          context.read<CustomCardBloc>().add(SelectImage());
        },
        child: Icon(
          Icons.image_outlined,
          size: 60,
          color: theme.colorScheme.onSurface.withOpacity(0.4),
        ),
      );
    }
  }
}
