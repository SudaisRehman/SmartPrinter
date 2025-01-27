import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// Base design dimensions (Figma design size)
const baseWidth = 375.0;
const baseHeight = 812.0;

class ResponsiveWidget extends StatelessWidget {
  final Widget Function(BuildContext context, Size size) builder;

  const ResponsiveWidget({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return builder(context, size);
  }
}

extension SizeExtension on num {
  double get w => (this / baseWidth) * MediaQueryData.fromView(ui.window).size.width;
  double get h => (this / baseHeight) * MediaQueryData.fromView(ui.window).size.height;

  // Scale text based on the average scale of width and height to maintain proportionality
  double get fontSize {
    double scale = MediaQueryData.fromView(ui.window).size.width / baseWidth;
    double heightScale = MediaQueryData.fromView(ui.window).size.height / baseHeight;
    return this * (scale + heightScale) / 2;
  }

  // For icon sizes (reuse fontSize for consistent scaling)
  double get iconSize => fontSize;
}
