import 'package:flutter/material.dart';

class ParalaxBackground extends StatelessWidget {
  const ParalaxBackground({
    super.key,
    required this.asset,
    this.top,
    this.height = 350,
  });
  
  final double? top;
  final String asset;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: SizedBox(
        height: height,
        child: Image(image: AssetImage(asset),
        fit: BoxFit.cover,)
        )
    );
  }
}