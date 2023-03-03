import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DabSvg extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;

  const DabSvg(
    this.assetName, {
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture(
      AssetBytesLoader('$assetName.vec'),
      width: width ?? 24,
      height: height ?? 24,
      colorFilter: color != null
          ? ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
