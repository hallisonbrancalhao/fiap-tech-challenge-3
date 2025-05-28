import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// baseado no código https://github.com/gtgalone/currency_text_input_formatter/blob/main/lib/currency_text_input_formatter.dart
class CurrencyTextInputFormatter extends TextInputFormatter {
  CurrencyTextInputFormatter();

  final int decimalDigits = 2;
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: '',
    decimalDigits: 2,
  );

  num _newNumberValue = 0;
  String _newStringValue = '';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.contains(' ')) {
      return oldValue;
    }

    String newTextValue = _removeNonNumericCharacters(newValue.text);

    _formatter(newTextValue);

    if (newTextValue.trim() == '' ||
        newTextValue == '00' ||
        newTextValue == '000') {
      return TextEditingValue(selection: TextSelection.collapsed(offset: 0));
    }

    // Adiciona novo "número" no final da string
    return TextEditingValue(
      text: _newStringValue,
      selection: TextSelection.collapsed(offset: _newStringValue.length),
    );
  }

  // Methods
  String getFormattedValue() {
    return _newStringValue;
  }

  String formatString(String value) {
    final String newText = _removeNonNumericCharacters(value);
    _formatter(newText);
    return _newStringValue;
  }

  String formatDouble(double value) {
    final String newText = value
        .toStringAsFixed(decimalDigits)
        .replaceAll(RegExp('[^0-9]'), '');
    _formatter(newText);
    return _newStringValue;
  }

  double getDouble() {
    return _newNumberValue.toDouble();
  }

  String _removeNonNumericCharacters(String stringValue) {
    return stringValue.replaceAll(RegExp('[^0-9]'), '');
  }

  // transforma string em number e depois divíde por 100
  // a divisão por 100 faz com que o número seja escrito da direta para a esquerda nas casas decimais
  num _parseStringToNumber(String text) {
    return (num.tryParse(text) ?? 0) / 100;
  }

  void _formatter(String stringValue) {
    _newNumberValue = _parseStringToNumber(stringValue);
    _newStringValue = currencyFormatter.format(_newNumberValue).trim();
  }
}
