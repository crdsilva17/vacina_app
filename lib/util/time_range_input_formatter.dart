import 'package:flutter/services.dart';

class TimeRangeInputFormatter extends TextInputFormatter {
  bool _isValidPartialTime(String value) {
    // Remove tudo que não for número
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    //H
    if (digits.isNotEmpty) {
      final hour1 = int.tryParse(digits.substring(0, 1));
      if (hour1 != null && hour1 > 2) {
        return false;
      }
    }
    // HH
    if (digits.length >= 2) {
      final hour = int.tryParse(digits.substring(0, 2));

      if (hour == null || hour > 23) {
        return false;
      }
    }

    //HHm
    if (digits.length >= 3) {
      final minute1 = int.tryParse(digits.substring(2, 3));

      if (minute1 == null || minute1 > 5) {
        return false;
      }
    }

    // HHmm
    if (digits.length >= 4) {
      final minute = int.tryParse(digits.substring(2, 4));

      if (minute == null || minute > 59) {
        return false;
      }
    }

    if (digits.length >= 5) {
      final h2 = int.tryParse(digits.substring(4, 5));
      if (h2 != null && h2 > 2) {
        return false;
      }
    }

    // Segunda hora
    if (digits.length >= 6) {
      final hour2 = int.tryParse(digits.substring(4, 6));

      if (hour2 == null || hour2 > 23) {
        return false;
      }
    }

    if (digits.length >= 7) {
      final minute21 = int.tryParse(digits.substring(6, 7));

      if (minute21 == null || minute21 > 5) {
        return false;
      }
    }

    // Segundo minuto
    if (digits.length >= 8) {
      final minute2 = int.tryParse(digits.substring(6, 8));

      if (minute2 == null || minute2 > 59) {
        return false;
      }
    }

    return true;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limite máximo -> HHmmHHmm
    if (digits.length > 8) {
      return oldValue;
    }

    // Validação
    if (!_isValidPartialTime(digits)) {
      return oldValue;
    }

    String formatted = '';

    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];

      // HH:
      if (i == 1 && digits.length > 2) {
        formatted += ':';
      }

      // HH:mm -
      if (i == 3 && digits.length > 4) {
        formatted += ' - ';
      }

      // HH:mm - HH:
      if (i == 5 && digits.length > 6) {
        formatted += ':';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
