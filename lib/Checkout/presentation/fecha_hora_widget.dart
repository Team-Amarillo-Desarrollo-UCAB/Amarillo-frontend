import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FechaHoraSelector extends StatefulWidget {
  final Function(DateTime) onDateTimeSelected;
  const FechaHoraSelector({super.key, required this.onDateTimeSelected});
  @override
  FechaHoraSelectorState createState() => FechaHoraSelectorState();
}

class FechaHoraSelectorState extends State<FechaHoraSelector> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _updateDateTime();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _updateDateTime();
      });
    }
  }

  void _updateDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      final DateTime selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      widget.onDateTimeSelected(selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () => _selectDate(context),
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.orange,
          ),
          label: const Text(
            'Seleccionar fecha',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.orange),
          ),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => _selectTime(context),
          icon: const Icon(
            Icons.access_time,
            color: Colors.orange,
          ),
          label: const Text(
            'Seleccionar hora',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.orange),
          ),
        ),
        if (_selectedDate != null && _selectedTime != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Fecha y Hora seleccionada: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
                _selectedTime!.hour,
                _selectedTime!.minute,
              ))}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}
