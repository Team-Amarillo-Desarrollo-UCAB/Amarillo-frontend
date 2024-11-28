import 'package:desarrollo_frontend/domain/Combo/combo.dart';
import 'package:flutter/material.dart';

class DetailComboScreen extends StatelessWidget {
  final Combo combo;
  final VoidCallback onAdd;

  const DetailComboScreen(
      {super.key, required this.combo, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
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
          CircleAvatar(
              backgroundImage: combo.image as ImageProvider<Object>,
              radius: 80),
          // Muestra la imagen del producto
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
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra el Row horizontalmente
            children: [
              const Text(
                'Precio:',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8), // Espacio entre "Precio:" y el valor
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
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
