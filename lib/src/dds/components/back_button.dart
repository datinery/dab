import 'package:dab/src/dds/dab_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

import 'appbar_button.dart';

class DabBackButton extends StatelessWidget {
  final Color? color;
  final GestureTapCallback? onTap;

  DabBackButton({this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final backButtonSvg = DabTheme.of(context).backButtonSvg;
    return DabAppBarButton(
      onTap: () {
        onTap != null ? onTap!() : Navigator.of(context).pop();
      },
      child: backButtonSvg != null
          ? SvgPicture.asset(
              backButtonSvg,
              color: color,
              width: 24,
              height: 24,
            )
          : Icon(
              LineIcons.arrowLeft,
              color: color,
            ),
    );
  }
}
