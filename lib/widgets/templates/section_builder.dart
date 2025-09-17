import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart';
import 'package:grocery_app/widgets/templates/category_section_template.dart'
    as s;
import 'package:grocery_app/widgets/card/custom_card.dart';

import 'promotion_template.dart';

Widget sectionBuilder({required Section section}) {
  switch (section.type) {
    case "category":
      return BlocProvider<SectionBuilderBloc>(
        create: (context) =>
            SectionBuilderBloc()..add(SetSection(section: section)),
        child: s.CategorySection(),
      );
    case "promotion":
      return BlocProvider<SectionBuilderBloc>(
        create: (context) => SectionBuilderBloc()
          ..add(
            SetSection(section: section),
          ),
        child: PromotionTemplate(),
      );
    default:
      return Container();
  }
}
