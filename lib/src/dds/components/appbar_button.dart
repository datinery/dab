import 'package:dab/dab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DabAppBarButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;

  DabAppBarButton({
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DabTheme.of(context);
    final appBarButtonWidth = theme.appBarButtonWidth ?? kAppBarIconButtonWidth;
    final appBarTextButtonHorizontalPadding =
        theme.appBarTextButtonHorizontalPadding ?? 8;

    Widget gestureDetectorChild;

    if (child is Icon) {
      gestureDetectorChild = SizedBox(
        width: appBarButtonWidth,
        height: kAppBarHeight,
        child: Center(child: child),
      );
    } else if (child is SvgPicture) {
      gestureDetectorChild = SizedBox(
        height: kAppBarHeight,
        width: appBarButtonWidth,
        child: Center(child: child),
      );
    } else if (child is DabText &&
        (child as DabText).data != null &&
        (child as DabText).data!.length <= 2) {
      gestureDetectorChild = SizedBox(
        width: appBarButtonWidth,
        height: kAppBarHeight,
        child: Center(
          child: child,
        ),
      );
    } else {
      gestureDetectorChild = SizedBox(
        height: kAppBarHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appBarTextButtonHorizontalPadding,
          ),
          child: Center(
            child: child,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: gestureDetectorChild,
    );
  }
}
