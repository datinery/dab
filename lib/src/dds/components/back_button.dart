import 'package:dab/src/dds/dab_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'appbar_button.dart';

class DabBackButton extends StatelessWidget {
  final Color? color;
  final GestureTapCallback? onTap;

  const DabBackButton({this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final backButtonSvg = DabTheme.of(context).backButtonSvg;
    return DabAppBarButton(
      onTap: () {
        onTap != null ? onTap!() : Navigator.of(context).pop();
      },
      child: SvgPicture(
        AssetBytesLoader('$backButtonSvg.vec'),
        width: 24,
        height: 24,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              )
            : null,
      ),
    );
  }
}
