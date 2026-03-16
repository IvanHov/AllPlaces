import 'dart:math' as math;

import 'package:flutter/services.dart';

class Phone998Formatter extends TextInputFormatter {
  const Phone998Formatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If user is deleting and cursor is at the beginning of "+998", allow deletion
    if (newValue.text.isEmpty ||
        (newValue.text.length < oldValue.text.length &&
            newValue.selection.baseOffset <= 4)) {
      // If completely empty or deleting prefix, return "+998"
      if (newValue.text.isEmpty || !newValue.text.startsWith('+998')) {
        return const TextEditingValue(
          text: '+998',
          selection: TextSelection.collapsed(offset: 4),
        );
      }
    }

    // Keep only digits from the new value
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Remove leading country code if present; subscriber should be 9 digits
    if (digits.startsWith('998')) {
      digits = digits.substring(3);
    }

    // Cap to 9 subscriber digits
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    final b = StringBuffer('+998');
    if (digits.isNotEmpty) b.write(' ');

    // Grouping: 2 3 4
    if (digits.isNotEmpty) {
      final g1 = digits.substring(0, math.min(2, digits.length));
      final g2Start = g1.length;
      final g2End = math.min(g2Start + 3, digits.length);
      final g2 = g2End > g2Start ? digits.substring(g2Start, g2End) : '';
      final g3Start = g2End;
      final g3 = g3Start < digits.length ? digits.substring(g3Start) : '';

      b.write(g1);
      if (g2.isNotEmpty) b.write(' $g2');
      if (g3.isNotEmpty) b.write(' $g3');
    }

    final formatted = b.toString();

    // Calculate cursor position more accurately
    int cursorPosition = formatted.length;
    if (newValue.selection.baseOffset < oldValue.text.length) {
      // User is deleting, try to maintain reasonable cursor position
      cursorPosition = math.min(
        newValue.selection.baseOffset,
        formatted.length,
      );
      // Don't allow cursor before "+998 "
      if (cursorPosition < 4) cursorPosition = 4;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
