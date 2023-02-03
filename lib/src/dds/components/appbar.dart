import 'package:dab/dab.dart';
import 'package:flutter/material.dart';

class DabAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final TextStyle? titleTextStyle;
  final Widget? child;
  final Color? backgroundColor;
  final Color? buttonColor;
  final List<Widget>? leftChildren;
  final List<Widget>? rightChildren;
  final double? height;

  DabAppBar({
    this.leftChildren,
    this.rightChildren,
    this.title,
    this.titleTextStyle,
    this.child,
    this.backgroundColor,
    this.buttonColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final theme = DabTheme.of(context);

    return Container(
      color: backgroundColor ?? Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            if (title != null || child != null)
              Center(
                child: title != null
                    ? DabText(
                        title!,
                        style: titleTextStyle ?? theme.appBarTitleTextStyle,
                        overflow: TextOverflow.ellipsis,
                      )
                    : child,
              ),
            Positioned(
              top: 0,
              left: theme.appBarHorizontalPadding ?? 0,
              bottom: 0,
              child: Container(
                color: backgroundColor ?? Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: leftChildren ??
                      (canPop
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
              right: theme.appBarHorizontalPadding ?? 0,
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
  Size get preferredSize => Size.fromHeight(height ?? kAppBarHeight);
}
