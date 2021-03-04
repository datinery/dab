import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'appbar_button.dart';

class DabCloseButton extends StatelessWidget {
  final Color /*?*/ color;

  DabCloseButton({@required this.color});

  @override
  Widget build(BuildContext context) {
    return DabAppBarButton(
      child: Icon(
        LineIcons.times,
        color: color,
      ),
      onTap: () => Navigator.of(context)?.pop(),
    );
  }
}
