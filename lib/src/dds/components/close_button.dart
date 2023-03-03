import 'package:dab/src/dds/components/dab_svg.dart';
import 'package:dab/src/dds/dab_theme.dart';
import 'package:flutter/material.dart';

import 'appbar_button.dart';

class DabCloseButton extends StatelessWidget {
  final Color? color;

  const DabCloseButton({this.color});

  @override
  Widget build(BuildContext context) {
    final closeButtonSvg = DabTheme.of(context).closeButtonSvg;
    return DabAppBarButton(
      child: DabSvg(closeButtonSvg, color: color),
      onTap: () => Navigator.of(context).pop(),
    );
  }
}
