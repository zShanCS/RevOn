import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BlurredBackground extends StatelessWidget {
  final double sigmaX;
  final double sigmaY;
  final Widget child;
  final String img;

  BlurredBackground({
    this.sigmaX = 50.0,
    this.sigmaY = 50.0,
    required this.child,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(child: imageOrBlurred(img)),
        ColoredBox(
          color: Colors.black.withOpacity(0.3),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
            child: child,
          ),
        ),
      ],
    );
  }
}

Widget imageOrBlurred(url) {
  try {
    final c = Image.network(
      url,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      fit: BoxFit.cover,
      height: 300,
      width: 200,
    );
    return c;
  } catch (e) {
    print('Error occured');
    return SizedBox();
  }
}
