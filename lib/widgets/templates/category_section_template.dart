import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/dashboard_bloc/dashboard_bloc.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/pages/select_category/select_category.dart';
import '../../blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import '../../database_service.dart/db_service.dart';
import '../../models/category.dart';
import '../../models/product/productt.dart';
import '../../service_locator/service_locator.dart';
import '../shop_by_store.dart';
import '../sliver_category.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionBuilderState();
}

class _CategorySectionBuilderState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    void setCategory(List<Category>? category) {
      context
          .read<SectionBuilderBloc>()
          .add(MultiSelectContent<Category>(content: category!));
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BlocBuilder<SectionBuilderBloc, SectionBuilderState>(
                  builder: (context, state) {
                    return TextField(
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: "Type Section Name",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        border: InputBorder.none, // removes the outline border
                        enabledBorder:
                            InputBorder.none, // removes when not focused
                        focusedBorder: InputBorder.none, // removes when focused
                        disabledBorder:
                            InputBorder.none, // removes when disabled
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onChanged: (value) {
                        context
                            .read<SectionBuilderBloc>()
                            .add(FieldChange(field: "name", value: value));
                      },
                    );
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    context.read<DashboardBloc>().add(SavePage());
                  },
                  icon: Icon(Icons.select_all))
            ],
          ),
          SizedBox(
            child: BlocConsumer<SectionBuilderBloc, SectionBuilderState>(
                listener: (context, state) {
              if (state.section != null && state.section!.content.isNotEmpty) {
                context
                    .read<DashboardBloc>()
                    .add(AddSectionToSave(section: state.section!));
              }
            }, builder: (context, state) {
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
                            // open category selector
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => FetchCategoryBloc(
                                        ServiceLocator()
                                            .get<DBService<Category>>(),
                                        ServiceLocator().getWithParam<
                                            DBService<Productt>,
                                            String>("products"),
                                      )..add(FetchCategories()),
                                    ),
                                  ],
                                  child: SelectCategory(
                                    onMultiSelect: (category) =>
                                        setCategory(category),
                                  ),
                                ),
                              ),
                            );
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   state.field["name"].toString(),
                    //   style: TextStyle(
                    //       fontSize: 18, fontWeight: FontWeight.bold),
                    // ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      // 👇 Add one more slot if content < 6
                      itemCount: content.length < 6
                          ? content.length + 1
                          : content.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        if (index < content.length) {
                          // Normal category tile
                          return Stack(
                            children: [
                              _buildSection("category", content[index]),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<SectionBuilderBloc>()
                                        .add(RemoveContent(index: index));
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          // Extra "+ Add Category" tile
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) => FetchCategoryBloc(
                                          ServiceLocator()
                                              .get<DBService<Category>>(),
                                          ServiceLocator().getWithParam<
                                              DBService<Productt>,
                                              String>("products"),
                                        )..add(FetchCategories()),
                                      ),
                                    ],
                                    child: SelectCategory(
                                      onMultiSelect: (category) =>
                                          setCategory(category),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                      alpha: 0.1, blue: 1, red: 0.5),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ], borderRadius: BorderRadius.circular(10)),
                              child: const Center(child: Icon(Icons.add)),
                            ),
                          );
                        }
                      },
                    )
                  ],
                );
              }
              return SizedBox.shrink();
            }),
          )
        ],
      ),
    );
  }
}

Widget _buildSection(String type, Category category) {
  if (type == "category") {
    return DashboardCategory(category: category);
  }
  if (type == "store") {
    return ShopByStore(category: category);
  }
  return Container();
}
