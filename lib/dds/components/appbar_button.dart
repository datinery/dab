import 'package:flutter/material.dart';

import '../constants.dart';
import 'text.dart';

class DabAppBarButton extends StatelessWidget {
  final Widget /*?*/ child;
  final GestureTapCallback onTap;
  final double appBarButtonWidth;
  final double appBarTextButtonHorizontalPadding;

  DabAppBarButton({
    @required this.onTap,
    @required this.child,
    this.appBarButtonWidth = 44,
    this.appBarTextButtonHorizontalPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    if (child is Icon) {
      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: appBarButtonWidth,
          height: kAppBarHeight,
          child: Center(child: child),
        ),
      );
    }

    if (child is DabText && (child as DabText).data.length <= 2) {
      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: appBarButtonWidth,
          height: kAppBarHeight,
          child: Center(
            child: child,
          ),
        ),
      );
    }

    if (child is DabText) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appBarTextButtonHorizontalPadding,
          ),
          child: SizedBox(
            height: kAppBarHeight,
            child: Center(
              child: child,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}
