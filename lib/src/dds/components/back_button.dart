import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'appbar_button.dart';

class DabBackButton extends StatelessWidget {
  final Color? color;
  final GestureTapCallback? onTap;

  DabBackButton({this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DabAppBarButton(
      onTap: () {
        onTap != null ? onTap!() : Navigator.of(context).pop();
      },
      child: Icon(
        LineIcons.arrowLeft,
        color: color,
      ),
    );
  }
}
