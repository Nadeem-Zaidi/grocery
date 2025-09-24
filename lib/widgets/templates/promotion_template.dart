import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/card/customcard/customcard_bloc.dart';
import 'package:grocery_app/blocs/section/dashboard_bloc/dashboard_bloc.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/models/custom_cards/customcard.dart';
import 'package:grocery_app/models/page_builder/page_builder.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart';
import 'package:grocery_app/widgets/card/custom_card.dart';

class PromotionTemplate extends StatefulWidget {
  const PromotionTemplate({super.key});

  @override
  State<PromotionTemplate> createState() => _PromotionTemplateState();
}

class _PromotionTemplateState extends State<PromotionTemplate> {
  @override
  Widget build(BuildContext context) {
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
                      context
                          .read<SectionBuilderBloc>()
                          .add(MultiSelectContent<PlainCard>(content: [
                            PlainCard(
                                title: '',
                                imageUrl: '',
                                backGroundColor: hexColor ?? ""),
                          ]));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Select Category"),
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

          return Container(
            height: 230,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Section Name",
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: content.length + 1,
                    itemBuilder: (context, index) {
                      if (index < content.length) {
                        return BlocProvider<CustomCardBloc>(
                            create: (context) => CustomCardBloc(),
                            child: PromoCard(hexColor: hexColor));
                      } else {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<SectionBuilderBloc>()
                                .add(MultiSelectContent<PlainCard>(content: [
                                  PlainCard(
                                      title: '',
                                      imageUrl: '',
                                      backGroundColor: hexColor ?? ""),
                                ]));
                          },
                          child: Container(
                            width: 85,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.1, blue: 1, red: 0.5),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ], borderRadius: BorderRadius.circular(10)),
                            child: const Center(child: Icon(Icons.add)),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          height: 280,
          decoration: BoxDecoration(),
          child: Column(
            children: [],
          ),
        );
      },
    );
  }
}
