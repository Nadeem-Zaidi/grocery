import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/card/customcard/customcard_bloc.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/models/custom_cards/customcard.dart';
import 'package:grocery_app/widgets/cards/promo_cards.dart';
import '../../blocs/section/dashboard_bloc/dashboard_bloc.dart';
import '../../utils/screen_utils.dart';

class AppbarPromoGridView extends StatelessWidget {
  const AppbarPromoGridView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtils.getScreenWidth(context);
    double screenHeight = ScreenUtils.getScreenHeight(context);
    String? hexColor =
        context.read<DashboardBloc>().state.page.dominantColorAppBar;
    return BlocConsumer<SectionBuilderBloc, SectionBuilderState>(
      listener: (context, state) {
        context
            .read<DashboardBloc>()
            .add(AddPromoToSave(section: state.section!));
      },
      builder: (context, state) {
        if (state.section != null && state.section!.content.isEmpty) {
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 48,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No Items Selected",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap below to choose Items for this section",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SectionBuilderBloc>().add(
                              MultiSelectContent<PlainCard>(content: [
                            PlainCard.initial()
                                .copyWith(backGroundColor: hexColor)
                          ]));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Items"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.section != null && state.section!.content.isNotEmpty) {
          var content = state.section!.content;
          double spacing = 5;
          double cardWidth =
              (screenWidth - spacing * 4) / 3; // 3 cards + 4 spaces
          double cardHeight = (cardWidth * 4 / 3) - 30;
          return Container(
            height: 300,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
            child: Column(
              children: [
                SizedBox(height: 5),
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    children: List.generate(content.length + 1, (index) {
                      if (index < content.length) {
                        return BlocProvider<CustomCardBloc>(
                          key: ValueKey(index + 8),
                          create: (context) => CustomCardBloc(),
                          child: Stack(children: [
                            SizedBox(
                              height: cardHeight,
                              width: cardWidth,
                              child: PromoCard(
                                key: ValueKey(index + 3),
                                hexColor: hexColor,
                                imageUrl: content[index]
                                        .imageUrl
                                        .toString()
                                        .isNotEmpty
                                    ? content[index].imageUrl
                                    : null,
                                index: index,
                              ),
                            ),
                            Positioned(
                              left: 2,
                              top: 5,
                              child: GestureDetector(
                                onTap: () {
                                  context.read<SectionBuilderBloc>().add(
                                      RemoveContent<PlainCard>(index: index));
                                },
                                child: Icon(Icons.cancel),
                              ),
                            )
                          ]),
                        );
                      } else {
                        return Container(
                          height: cardHeight,
                          width: cardWidth,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                context.read<SectionBuilderBloc>().add(
                                      MultiSelectContent<PlainCard>(
                                        content: [
                                          PlainCard.initial().copyWith(
                                              backGroundColor: hexColor)
                                        ],
                                      ),
                                    );
                              },
                              child: Icon(Icons.add),
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                  //   child: GridView.builde r(
                  //       itemCount: content.length + 1,
                  //       shrinkWrap: true,
                  //       scrollDirection: Axis.horizontal,
                  //       // physics: const NeverScrollableScrollPhysics(),
                  //       padding: EdgeInsets.zero,
                  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2, childAspectRatio: 1.5),
                  //       itemBuilder: (context, index) {
                  //         if (index < content.length) {
                  //           return BlocProvider<CustomCardBloc>(
                  //             create: (context) => CustomCardBloc(),
                  //             child: Stack(children: [
                  //               PromoCard(
                  //                 hexColor: hexColor,
                  //               ),
                  //               Positioned(
                  //                 left: 2,
                  //                 top: 5,
                  //                 child: GestureDetector(
                  //                   onTap: () {
                  //                     context.read<SectionBuilderBloc>().add(
                  //                         RemoveContent<PlainCard>(index: index));
                  //                   },
                  //                   child: Icon(Icons.cancel),
                  //                 ),
                  //               )
                  //             ]),
                  //           );
                  //         } else {
                  //           return GestureDetector(
                  //             onTap: () {
                  //               context.read<SectionBuilderBloc>().add(
                  //                     MultiSelectContent<PlainCard>(
                  //                       content: [
                  //                         PlainCard.initial()
                  //                             .copyWith(backGroundColor: hexColor)
                  //                       ],
                  //                     ),
                  //                   );
                  //             },
                  //           );
                  //         }
                  //       }),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
