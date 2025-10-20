import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/cards/custom_card.dart';

import '../../../../utils/screen_utils.dart';

class AppBarBackgroundBuilder extends StatefulWidget {
  final Widget backGroundBuilder;
  final Widget promoBannerBuilder;
  final double dynamicHeight;
  final VoidCallback onHeightIncreement;
  final VoidCallback onHeightDecreement;
  const AppBarBackgroundBuilder(
      {super.key,
      required this.backGroundBuilder,
      required this.promoBannerBuilder,
      required this.dynamicHeight,
      required this.onHeightIncreement,
      required this.onHeightDecreement});

  @override
  State<AppBarBackgroundBuilder> createState() => _AppBarBackgroundState();
}

class _AppBarBackgroundState extends State<AppBarBackgroundBuilder> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtils.getScreenHeight(context);
    double screenWidth = ScreenUtils.getScreenWidth(context);
    return SizedBox(
      height: screenHeight * widget.dynamicHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.backGroundBuilder,
          widget.promoBannerBuilder,
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                color: Colors.white,
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              child: CustomPaint(
                painter: FolderShapePainter(title: "Top Deals"),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: widget.onHeightIncreement,
              child: Icon(Icons.expand_more),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: widget.onHeightDecreement,
              child: Icon(Icons.expand_less),
            ),
          )
        ],
      ),
    );
  }
}
