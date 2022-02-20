extension StringExtension on String {
  bool get isWhitespace => RegExp(r'\s+').stringMatch(this) == this;
  bool get isNotWhitespace => !isWhitespace;
  String? get nullIfEmpty => isEmpty ? null : this;

  String toHalfWidth() {
    final convertedCharCodes = codeUnits.map((charCode) {
      if (0xFF00 < charCode && charCode < 0xFF5F) {
        return 0x0020 + (charCode - 0xFF00);
      }

      if (0x3000 == charCode) {
        return 0x0020;
      }

      if (0x2212 == charCode) {
        return 0x2D;
      }

      return charCode;
    });

    return String.fromCharCodes(convertedCharCodes);
  }
}
