import 'package:flutter/material.dart';

class FechaHoraSelector extends StatefulWidget {
  const FechaHoraSelector({super.key});
  @override
  FechaHoraSelectorState createState() => FechaHoraSelectorState();
}

class FechaHoraSelectorState extends State<FechaHoraSelector> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sección de la fecha
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Fecha:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 50),
            SizedBox(
              width: 50,
              child: TextField(
                controller: _dayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'DD'),
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 50,
              child: TextField(
                controller: _monthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'MM'),
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),

        // Sección de la hora
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              ' Hora:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 50),
            SizedBox(
              width: 50,
              child: TextField(
                controller: _hourController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'HH'),
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 50,
              child: TextField(
                controller: _minuteController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'MM'),
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
