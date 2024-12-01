import 'package:desarrollo_frontend/domain/Combo/combo.dart';
import 'package:flutter/material.dart';

void showDetailComboDialog(
    BuildContext context, Combo combo, VoidCallback onAdd) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenido
          children: [
            Text(
              combo.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            CircleAvatar(
                backgroundImage: combo.image as ImageProvider<Object>,
                radius: 80),
            const SizedBox(height: 16),
            const Text(
              'Descripción:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: combo.description.map((detailItem) {
                  return Text(
                    detailItem,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Colors.grey),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Precio:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${combo.price} USD',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  combo.peso,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Agregar al carrito',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
