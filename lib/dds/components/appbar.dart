import 'package:flutter/material.dart';

import '../constants.dart';
import 'back_button.dart';
import 'close_button.dart';
import 'text.dart';

class DabAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final TextStyle titleTextStyle;
  final Widget child;
  final Color backgroundColor;
  final Color buttonColor;
  final List<Widget> leftChildren;
  final List<Widget> rightChildren;

  DabAppBar({
    this.leftChildren,
    this.rightChildren,
    this.title,
    this.titleTextStyle,
    this.child,
    this.backgroundColor,
    this.buttonColor,
  }) : assert(!(title != null && child != null));

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context)?.canPop();
    final ModalRoute<dynamic> /*?*/ parentRoute = ModalRoute.of(context);
    final useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: backgroundColor ?? Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            if (title != null || child != null)
              Center(
                child: title != null
                    ? DabText(
                        title,
                        style: titleTextStyle,
                        overflow: TextOverflow.ellipsis,
                      )
                    : child,
              ),
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              child: Container(
                color: backgroundColor ?? Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: leftChildren ??
                      (canPop != null && canPop
                          ? [
                              useCloseButton
                                  ? DabCloseButton(color: buttonColor)
                                  : DabBackButton(color: buttonColor)
                            ]
                          : []),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: backgroundColor ?? Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: rightChildren ?? [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kAppBarHeight);
}
