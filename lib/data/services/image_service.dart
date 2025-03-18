// create class for image config
import 'package:flutter/material.dart';

Widget customAssetPath(
    {required String imagePath,
    double? size,
    double? width,
    BoxFit? fit,
    Color? color}) {
  return Image.asset(
    imagePath.toString(),
    height: size,
    width: width,
    fit: fit,
    color: color,
  );
}

class ImageConfig {
  static const String menuIcon = 'assets/icons/menu.png';
}
