import 'package:flutter/material.dart';

typedef TextStyleFn = TextStyle Function(BuildContext context);

class DabTheme extends InheritedWidget {
  final String backButtonSvg;
  final String closeButtonSvg;
  final double? appBarButtonWidth;
  final double? appBarTextButtonHorizontalPadding;
  final double? appBarHorizontalPadding;
  final TextStyleFn? appBarTitleTextStyle;

  const DabTheme({
    Key? key,
    required Widget child,
    required this.backButtonSvg,
    required this.closeButtonSvg,
    this.appBarButtonWidth,
    this.appBarTextButtonHorizontalPadding,
    this.appBarHorizontalPadding,
    this.appBarTitleTextStyle,
  }) : super(key: key, child: child);

  static DabTheme of(BuildContext context) {
    final DabTheme? result =
        context.dependOnInheritedWidgetOfExactType<DabTheme>();
    assert(result != null, 'No DabTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DabTheme old) {
    return false;
  }
}
