import 'package:dab/dab.dart';
import 'package:flutter/material.dart';

class DabAppBar extends StatelessWidget with PreferredSizeWidget {
  final dynamic title;
  final TextStyle? titleTextStyle;
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
    this.backgroundColor,
    this.buttonColor,
    this.height,
  }) : assert(title == null || title is Widget || title is String);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final theme = DabTheme.of(context);
    final appBarHorizontalPadding =
        DabTheme.of(context).appBarHorizontalPadding;
    final appBarHeight = height ?? kAppBarHeight;

    return Container(
      color: backgroundColor ?? Colors.transparent,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: appBarHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: appBarHorizontalPadding),
                    if (leftChildren != null)
                      ...leftChildren!
                    else if (canPop)
                      useCloseButton
                          ? const DabCloseButton()
                          : const DabBackButton(),
                    const Spacer(),
                    ...(rightChildren ?? []),
                    SizedBox(width: appBarHorizontalPadding),
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: appBarHeight),
              child: title != null
                  ? Center(
                      child: title is Widget
                          ? title
                          : Text(
                              title,
                              style:
                                  titleTextStyle ?? theme.appBarTitleTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kAppBarHeight);
}
