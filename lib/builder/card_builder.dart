import 'package:flutter/material.dart';

class CardBuilder<T> extends StatelessWidget {
  final List<T> content;
  final double cardHeight;
  final double cardWidth;
  final double containerHeight;
  final Color? hexColor;
  final void Function(int index)? onRemoveCard;
  final VoidCallback? onAddCard;
  final void Function(int index)? onChangeBackground;
  final Widget Function(T itemn, int index) itemBuilder;
  final bool wrap;
  const CardBuilder(
      {super.key,
      required this.content,
      required this.cardHeight,
      required this.cardWidth,
      required this.containerHeight,
      this.hexColor,
      required this.onRemoveCard,
      required this.onAddCard,
      required this.itemBuilder,
      this.wrap = false,
      this.onChangeBackground});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: containerHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
          ),
          child: wrap
              ? Column(
                  children: [
                    SizedBox(height: 5),
                    Expanded(
                      child: Wrap(
                        spacing: 5,
                        children: List.generate(content.length + 1, (index) {
                          if (index < content.length) {
                            final item = content[index];

                            return Stack(children: [
                              SizedBox(
                                height: cardHeight,
                                width: cardWidth,
                                child: itemBuilder(item, index),
                              ),
                              Positioned(
                                left: 2,
                                top: 5,
                                child: GestureDetector(
                                  onTap: () => onRemoveCard?.call(index),
                                  child: Icon(Icons.cancel),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: GestureDetector(
                                    onTap: () =>
                                        onChangeBackground?.call(index),
                                    child: Icon(Icons.edit),
                                  ))
                            ]);
                          } else {
                            return SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: Center(
                                child: GestureDetector(
                                  onTap: onAddCard,
                                  child: Icon(Icons.add),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(content.length + 1, (index) {
                        if (index < content.length) {
                          final item = content[index];

                          return Stack(children: [
                            SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: itemBuilder(item, index),
                            ),
                            Positioned(
                              left: 2,
                              top: 5,
                              child: GestureDetector(
                                onTap: () => onRemoveCard?.call(index),
                                child: Icon(Icons.cancel),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: GestureDetector(
                                  onTap: () => onChangeBackground,
                                  child: Icon(Icons.edit),
                                ))
                          ]);
                        } else {
                          return SizedBox(
                            height: cardHeight,
                            width: cardWidth,
                            child: Center(
                              child: GestureDetector(
                                onTap: onAddCard,
                                child: Icon(Icons.add),
                              ),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
