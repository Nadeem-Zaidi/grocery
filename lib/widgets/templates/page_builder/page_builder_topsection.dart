import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/section/dashboard_bloc/dashboard_bloc.dart';

Color getContrastingTextColor(BuildContext context, bool shouldStick,
    bool changeColor, Color background, DashboardState state) {
  final brightness = View.of(context).platformDispatcher.platformBrightness;
  background = Theme.of(context).primaryColor;
  Color darkColor = Theme.of(context).primaryColor;
  if (shouldStick) {
    background =
        getColorFromString(state.page.dominantColorAppBar ?? "#FF616161");
  } else if (changeColor) {
    background = Theme.of(context).primaryColor;
  } else {
    background =
        getColorFromString(state.page.dominantColorAppBar ?? "#FF616161");
    darkColor = getColorFromString(state.page.darkDominantColor ?? "#FF616161");
  }

  final luminance = background.computeLuminance();
  final darkLuminance = darkColor.computeLuminance();
  // if (darkLuminance < luminance) {
  //   return Colors.white;
  // }

  return luminance > 0.5 ? Colors.black : Colors.white;

  // if (brightness == Brightness.dark) {
  //   return Colors.white; // Dark system theme -> white text
  // } else {
  //   // Light system theme -> pick based on background luminance
  //   return luminance > 0.5 ? Colors.black : Colors.white;
  // }
}

Color getColorFromString(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'ff$hex'; // assume fully opaque
  return Color(int.parse(hex, radix: 16));
}

// Define a gradient instead of a solid color

// Helper to get text color based on the first color of the gradient
Color getContrastingTextColorFromGradient(BuildContext context, Color color) {
  final brightness = View.of(context).platformDispatcher.platformBrightness;
  final luminance = color.computeLuminance();

  if (brightness == Brightness.dark) {
    return Colors.white;
  } else {
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

class StickyAppBar<T> extends StatefulWidget {
  final Offset offset;
  final bool shouldStick;
  final bool changeAppBarColor;
  final GlobalKey searchBarKey;
  final double scrollOffset;
  final double searchbarHeight;
  final T state;
  final GlobalKey appbarListSectionKey;
  const StickyAppBar(
      {super.key,
      this.offset = const Offset(0.0, 0.0),
      this.shouldStick = false,
      required this.changeAppBarColor,
      required this.searchBarKey,
      required this.searchbarHeight,
      required this.scrollOffset,
      required this.state,
      required this.appbarListSectionKey});

  @override
  State<StickyAppBar> createState() => _StickyAppBarState();
}

class _StickyAppBarState extends State<StickyAppBar> {
  @override
  Widget build(BuildContext context) {
    Color appBarColor = Theme.of(context).primaryColor;
    if (widget.state.page.dominantColorAppBar != null) {
      appBarColor = getColorFromString(widget.state.page.dominantColorAppBar!);
    }

    bool shouldStickColor = widget.shouldStick;
    if (widget.changeAppBarColor) {
      shouldStickColor = false;
    }

    return Transform.translate(
      offset: widget.shouldStick
          ? const Offset(0, 0)
          : Offset(0, -widget.scrollOffset),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top,
          16,
          0,
        ),
        decoration: BoxDecoration(
            color: shouldStickColor
                ? appBarColor
                : widget.changeAppBarColor
                    ? Theme.of(context).primaryColor
                    : Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.shouldStick)
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "12 Minutes Delivery",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: getContrastingTextColor(
                            context,
                            widget.shouldStick,
                            widget.changeAppBarColor,
                            appBarColor,
                            widget.state),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Home",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: getContrastingTextColor(
                                  context,
                                  widget.shouldStick,
                                  widget.changeAppBarColor,
                                  appBarColor,
                                  widget.state)),
                        ),
                        Text(
                          " - Last House",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: getContrastingTextColor(
                                  context,
                                  widget.shouldStick,
                                  widget.changeAppBarColor,
                                  appBarColor,
                                  widget.state)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              key: widget.searchBarKey,
              height: widget.searchbarHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Search for atta, dal, coffee...",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Icon(Icons.mic, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              key: widget.appbarListSectionKey,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryIcon(context, Icons.widgets, "All", appBarColor,
                    widget.shouldStick, widget.changeAppBarColor, widget.state),
                _buildCategoryIcon(
                    context,
                    Icons.umbrella,
                    "Monsoon",
                    appBarColor,
                    widget.shouldStick,
                    widget.changeAppBarColor,
                    widget.state),
                _buildCategoryIcon(
                    context,
                    Icons.headphones,
                    "Electronics",
                    appBarColor,
                    widget.shouldStick,
                    widget.changeAppBarColor,
                    widget.state),
                _buildCategoryIcon(
                    context,
                    Icons.auto_awesome,
                    "Beauty",
                    appBarColor,
                    widget.shouldStick,
                    widget.changeAppBarColor,
                    widget.state),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// Widget _buildStickyAppBar(BuildContext context, DashboardState state) {
//   bool shouldStickColor = _shouldStick;
//   if (_changeColorNormal) {
//     shouldStickColor = false;
//   }
//   Color? appBarColor;
//   if (state.page.dominantColorAppBar != null) {
//     appBarColor = getColorFromString(state.page.dominantColorAppBar!);
//   }

//   return Transform.translate(
//     offset: _shouldStick ? const Offset(0, 0) : Offset(0, -_scrollOffset),
//     child: AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       padding: EdgeInsets.fromLTRB(
//         16,
//         MediaQuery.of(context).padding.top,
//         16,
//         0,
//       ),
//       decoration: BoxDecoration(
//           color: shouldStickColor
//               ? appBarColor
//               : _changeColorNormal
//                   ? Theme.of(context).primaryColor
//                   : Colors.transparent),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!_shouldStick)
//             SizedBox(
//               height: 100,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "12 Minutes Delivery",
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: getContrastingTextColorFromGradient(
//                           context, appBarColor ?? Colors.black),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "Home",
//                         style: TextStyle(
//                             fontSize: 21,
//                             fontWeight: FontWeight.bold,
//                             color: getContrastingTextColorFromGradient(
//                                 context, appBarColor ?? Colors.black)),
//                       ),
//                       Text(
//                         " - Last House",
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: getContrastingTextColorFromGradient(
//                                 context, appBarColor ?? Colors.black)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           Container(
//             key: _searchByKey,
//             height: _searchbarheight,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(22),
//               color: Colors.white,
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: const Row(
//               children: [
//                 Icon(Icons.search, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     "Search for atta, dal, coffee...",
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ),
//                 Icon(Icons.mic, color: Colors.grey),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             key: _appbarListSection,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildCategoryIcon(context, Icons.widgets, "All", appBarColor),
//               _buildCategoryIcon(
//                   context, Icons.umbrella, "Monsoon", appBarColor),
//               _buildCategoryIcon(
//                   context, Icons.headphones, "Electronics", appBarColor),
//               _buildCategoryIcon(
//                   context, Icons.auto_awesome, "Beauty", appBarColor),
//             ],
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     ),
//   );
// }

Widget _buildCategoryIcon(
    BuildContext context,
    IconData icon,
    String label,
    Color appBarColor,
    bool shouldStick,
    bool changeAppBarColor,
    DashboardState state) {
  final textColor = getContrastingTextColor(
      context, shouldStick, changeAppBarColor, appBarColor, state);

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: textColor, size: 22),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          color: getContrastingTextColor(
              context, shouldStick, changeAppBarColor, appBarColor, state),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      Divider(
        thickness: 0.8,
        height: 3,
        color: Colors.grey, //
      ),
    ],
  );
}
