import 'package:flutter/services.dart';

class CepInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {

    // Remove tudo que não for número
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita em 8 números
    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    String formatted = '';

    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];

      // Adiciona o hífen após o quinto dígito
      if (i == 4 && digits.length > 5) {
        formatted += '-';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}