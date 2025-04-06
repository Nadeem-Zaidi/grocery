import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  List<String> imageUrls;
  ImageSlider({super.key, required this.imageUrls});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.imageUrls;
    return PageView.builder(
      itemCount: images.length,
      pageSnapping: true,
      controller: _pageController,
      itemBuilder: (context, pagePosition) {
        return Container(
          margin: EdgeInsets.all(10),
          child: Image.network(images[pagePosition]),
        );
      },
    );
  }
}
