import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'appbar_button.dart';

class DabBackButton extends StatelessWidget {
  final Color /*?*/ color;

  DabBackButton({@required this.color});

  @override
  Widget build(BuildContext context) {
    return DabAppBarButton(
      onTap: () => Navigator.of(context)?.pop(),
      child: Icon(
        LineIcons.arrowLeft,
        color: color,
      ),
    );
  }
}
