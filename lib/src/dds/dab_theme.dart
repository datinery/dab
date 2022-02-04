import 'package:flutter/material.dart';

class DabTheme extends InheritedWidget {
  final String? backButtonSvg;
  final String? closeButtonSvg;
  final double? appBarButtonWidth;
  final double? appBarTextButtonHorizontalPadding;
  final double? appBarHorizontalPadding;

  const DabTheme({
    Key? key,
    required Widget child,
    this.backButtonSvg,
    this.closeButtonSvg,
    this.appBarButtonWidth,
    this.appBarTextButtonHorizontalPadding,
    this.appBarHorizontalPadding,
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
