import 'package:flutter/material.dart';

import '../constants.dart';
import 'text.dart';

class DabAppBarButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final double appBarButtonWidth;
  final double appBarTextButtonHorizontalPadding;

  DabAppBarButton({
    required this.onTap,
    required this.child,
    this.appBarButtonWidth = kAppBarIconButtonWidth,
    this.appBarTextButtonHorizontalPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    Widget gestureDetectorChild;

    if (child is Icon) {
      gestureDetectorChild = SizedBox(
        width: appBarButtonWidth,
        height: kAppBarHeight,
        child: Center(child: child),
      );
    } else if (child is DabText && (child as DabText).data.length <= 2) {
      gestureDetectorChild = SizedBox(
        width: appBarButtonWidth,
        height: kAppBarHeight,
        child: Center(
          child: child,
        ),
      );
    } else if (child is DabText) {
      gestureDetectorChild = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: appBarTextButtonHorizontalPadding,
        ),
        child: SizedBox(
          height: kAppBarHeight,
          child: Center(
            child: child,
          ),
        ),
      );
    } else {
      gestureDetectorChild = Padding(
        padding:
            EdgeInsets.symmetric(horizontal: appBarTextButtonHorizontalPadding),
        child: child,
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: gestureDetectorChild,
    );
  }
}
