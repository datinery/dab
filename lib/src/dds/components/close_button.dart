import 'package:dab/src/dds/dab_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

import 'appbar_button.dart';

class DabCloseButton extends StatelessWidget {
  final Color? color;

  DabCloseButton({required this.color});

  @override
  Widget build(BuildContext context) {
    final closeButtonSvg = DabTheme.of(context).closeButtonSvg;
    return DabAppBarButton(
      child: closeButtonSvg != null
          ? SvgPicture.asset(
              closeButtonSvg,
              color: color,
              width: 24,
              height: 24,
            )
          : Icon(
              LineIcons.times,
              color: color,
            ),
      onTap: () => Navigator.of(context).pop(),
    );
  }
}
