import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/blocs/section/card/customcard/customcard_bloc.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/models/custom_cards/customcard.dart';
import 'package:grocery_app/widgets/cards/plain_promo_card.dart';
import 'package:grocery_app/widgets/utilities_widget/select_item.dart';
import '../../blocs/section/dashboard_bloc/dashboard_bloc.dart';
import '../../utils/screen_utils.dart';
import '../utilities_widget/grid_view_with_promocard.dart';

class AppbarPromoGridView extends StatelessWidget {
  final int numOfContentPerRow;
  final int numOfContentPerCol;
  String? hexColor;

  AppbarPromoGridView({
    super.key,
    this.numOfContentPerRow = 3,
    this.numOfContentPerCol = 2,
    this.hexColor,
  });

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  Color hexToColor(String hex, {double darken = 0}) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'ff$hex'; // assume fully opaque
    Color color = Color(int.parse(hex, radix: 16));

    if (darken <= 0) return color;

    // clamp the darken value between 0 and 1
    darken = darken.clamp(0, 1);

    final hsl = HSLColor.fromColor(color);
    final darkerHsl =
        hsl.withLightness((hsl.lightness - darken).clamp(0.0, 1.0));
    return darkerHsl.toColor();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtils.getScreenWidth(context);
    double screenHeight = ScreenUtils.getScreenHeight(context);
    late String? hexColor = this.hexColor ??
        context.read<DashboardBloc>().state.page.dominantColorAppBar;

    return Stack(
      children: [
        Container(height: screenHeight * 0.6, decoration: BoxDecoration()),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: BlocConsumer<SectionBuilderBloc, SectionBuilderState>(
            listener: (context, state) {
              context
                  .read<DashboardBloc>()
                  .add(AddPromoToSave(section: state.section!));
            },
            builder: (context, state) {
              if (state.section != null && state.section!.content.isEmpty) {
                return SelectItem(onPress: () {
                  context.read<SectionBuilderBloc>().add(
                        MultiSelectContent<PlainCard>(
                          content: [
                            PlainCard.initial().copyWith(
                                backGroundColor: hexColor,
                                color: state.contentbackGroundColor)
                          ],
                        ),
                      );
                });
              }

              if (state.section != null && state.section!.content.isNotEmpty) {
                var content = state.section!.content as List<PlainCard>;
                double containerHeight = screenHeight * 0.35;
                double cardWidth = (screenWidth / numOfContentPerRow) -
                    10; // 3 cards + 4 spaces
                double cardHeight = (containerHeight / numOfContentPerCol) - 20;
                return CardBuilder(
                    content: content,
                    cardHeight: cardHeight,
                    cardWidth: cardWidth,
                    containerHeight: containerHeight,
                    wrap: true,
                    onRemoveCard: (index) {
                      context
                          .read<SectionBuilderBloc>()
                          .add(RemoveContent<PlainCard>(index: index));
                    },
                    onAddCard: () {
                      context.read<SectionBuilderBloc>().add(
                            MultiSelectContent<PlainCard>(
                              content: [
                                PlainCard.initial()
                                    .copyWith(backGroundColor: hexColor)
                              ],
                            ),
                          );
                    },
                    onChangeBackground: (index) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: (color) {
                                context
                                    .read<SectionBuilderBloc>()
                                    .add(SelectContentBackground(color: color));
                              },
                            ),
                            // Use Material color picker:
                            //
                            // child: MaterialPicker(
                            //   pickerColor: pickerColor,
                            //   onColorChanged: changeColor,
                            //   showLabel: true, // only on portrait mode
                            // ),
                            //
                            // Use Block color picker:
                            //
                            // child: BlockPicker(
                            //   pickerColor: currentColor,
                            //   onColorChanged: changeColor,
                            // ),
                            //
                            // child: MultipleChoiceBlockPicker(
                            //   pickerColors: currentColors,
                            //   onColorsChanged: changeColors,
                            // ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    itemBuilder: (card, index) {
                      return PromoCard(
                        key: ValueKey(index),
                        hexColor: hexColor,
                        index: index,
                        color: state.contentbackGroundColor,
                        imageUrl: card.imageUrl,
                        cardHeight: cardHeight,
                        cardWidth: cardWidth,
                      );
                    });
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
