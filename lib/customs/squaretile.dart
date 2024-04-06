import 'package:flutter/material.dart';

class Squaretile extends StatelessWidget {
  final String imagePath;
  final double height;
  const Squaretile({super.key, required this.imagePath, required this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.asset(
      imagePath,
      height: height,
    ));
  }
}
