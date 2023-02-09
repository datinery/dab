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
      gestureDetectorChild = Container(
        width: appBarButtonWidth,
        height: double.infinity,
        child: Center(child: child),
      );
    } else if (child is SvgPicture) {
      gestureDetectorChild = Container(
        height: double.infinity,
        width: appBarButtonWidth,
        child: Center(child: child),
      );
    } else if (child is Text &&
        (child as Text).data != null &&
        (child as Text).data!.length <= 2) {
      gestureDetectorChild = Container(
        width: appBarButtonWidth,
        height: double.infinity,
        child: Center(
          child: child,
        ),
      );
    } else {
      gestureDetectorChild = Container(
        height: double.infinity,
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
