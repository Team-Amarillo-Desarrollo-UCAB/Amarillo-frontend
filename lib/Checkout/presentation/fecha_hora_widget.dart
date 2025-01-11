import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FechaHoraSelector extends StatefulWidget {
  final Function(DateTime) onDateTimeSelected;
  const FechaHoraSelector({super.key, required this.onDateTimeSelected});
  @override
  FechaHoraSelectorState createState() => FechaHoraSelectorState();
}

class FechaHoraSelectorState extends State<FechaHoraSelector> {
  DateTime? _selectedDateTime;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDateTime) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          widget.onDateTimeSelected(_selectedDateTime!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text('Seleccionar fecha y hora'),
        ),
        if (_selectedDateTime != null)
          Text(
            'Fecha y Hora seleccionada: ${DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!)}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
      ],
    );
  }
}
