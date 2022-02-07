import 'package:flutter/material.dart';

class DabText extends StatelessWidget {
  final String? data;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;

  DabText(
    this.data, {
    this.style,
    this.overflow,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return data != null
        ? Text(
            data!,
            style: style,
            overflow: overflow,
            textAlign: textAlign,
            maxLines: maxLines,
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          )
        : const SizedBox();
  }
}
