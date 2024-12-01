import 'package:desarrollo_frontend/domain/Carrito/cart_item.dart';
import 'package:flutter/material.dart';

void showDetailCartItemDialog(BuildContext context, CartItem product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenido
          children: [
            Text(
              product.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            CircleAvatar(
                backgroundImage: product.imageUrl as ImageProvider<Object>,
                radius: 80),
            const SizedBox(height: 16),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenido
          children: [
            const Text(
              'Descripción:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            _buildDescription(product.description),
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
                  '${product.price} USD',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  product.peso,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

Widget _buildDescription(dynamic description) {
  if (description is String) {
    return Text(
      description,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w900,
        fontSize: 15,
        color: Colors.grey,
      ),
    );
  } else if (description is List<dynamic>) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Column(
            children: description.map((detailItem) {
              return Text(
                detailItem,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  } else {
    // Handle unexpected data type (optional)
    return const Text(
      'Descripción no disponible',
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w900,
        fontSize: 15,
        color: Colors.grey,
      ),
    );
  }
}
