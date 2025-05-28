import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key, required this.onSelect, this.selectedDate});

  final void Function(DateTime? value) onSelect;
  final DateTime? selectedDate;

  static DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );

    onSelect(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _selectDate(context),
      icon: Icon(Icons.calendar_month),
      label:
          selectedDate != null
              ? Text(dateFormatter.format(selectedDate!))
              : Text('Data da transação'),
    );
  }
}
