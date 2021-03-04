import 'package:flutter/material.dart';

import '../constants.dart';

class DabScaffold extends StatelessWidget {
  final Widget body;
  final Widget appBar;
  final bool extendBodyBehindAppBar;

  DabScaffold({
    required this.body,
    required this.appBar,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: <Widget>[
          Positioned(
            top: extendBodyBehindAppBar ? 0 : kAppBarHeight,
            child: body,
            left: 0,
            right: 0,
            bottom: 0,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(height: kAppBarHeight, child: appBar),
          ),
        ]),
      ),
    );
  }
}
