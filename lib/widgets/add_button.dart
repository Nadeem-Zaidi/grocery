import 'package:flutter/material.dart';

class AddToCartButton extends StatefulWidget {
  final double height;
  final double width;
  final Color backGroundColor;
  final String buttonText;
  final Color? textColor;
  final double? borderRadius;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  const AddToCartButton(
      {super.key,
      required this.height,
      required this.width,
      required this.backGroundColor,
      required this.buttonText,
      this.textColor,
      this.borderRadius,
      this.borderColor,
      this.fontWeight,
      this.fontSize});

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    double height = widget.height;
    Color backGroundColor = widget.backGroundColor;
    Color? textColor = widget.textColor;
    String buttonText = widget.buttonText;
    double? borderRadius = widget.borderRadius;
    Color? borderColor = widget.borderColor;
    FontWeight? fontWeight = widget.fontWeight;
    double? fontSize = widget.fontSize;
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: backGroundColor,
          border: Border.all(
              color: borderColor ?? Theme.of(context).primaryColor, width: 1),
          borderRadius: BorderRadius.circular(borderRadius ?? 5.0)),
      child: Text(
        buttonText,
        style: TextStyle(
            color: textColor ?? Theme.of(context).primaryColor,
            fontWeight: fontWeight ?? FontWeight.bold,
            fontSize: fontSize ?? 16),
      ),
    );
  }
}
