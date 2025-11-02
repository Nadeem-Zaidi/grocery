import 'package:flutter/material.dart';

import 'page_builder/page_builder_bottom_navigator.dart';

class CreatePage extends StatefulWidget {
  final Widget? topSectionBackgroundBuilder;
  final Widget stickyTopSectionBuilder;
  final Widget listSection;
  final Widget? error;
  final ScrollController controller;

  const CreatePage({
    super.key,
    required this.topSectionBackgroundBuilder,
    required this.stickyTopSectionBuilder,
    required this.listSection,
    this.error,
    required this.controller,
  });

  @override
  State<CreatePage> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: widget.controller,
            slivers: [
              SliverToBoxAdapter(
                child: widget.topSectionBackgroundBuilder,
              ),
              widget.listSection
            ],
          ),
          widget.stickyTopSectionBuilder,
        ],
      ),
      bottomNavigationBar: PageBuilderBottomNavigatorBar(),
    );
  }
}
