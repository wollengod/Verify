import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color iconColor;
  final Color backgroundColor;
  final double height;
  final double width;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.height = 25,
    this.width = 25,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.all(10.0),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
