import 'package:desarrollo_frontend/Carrito/domain/cart_item.dart';
import 'package:flutter/material.dart';

void showDetailCartItemDialog(BuildContext context, CartItem product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final media = MediaQuery.of(context).size;

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(media.width * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    fontSize: media.width * 0.05,
                  ),
                ),
                SizedBox(height: media.height * 0.02),
                CircleAvatar(
                  backgroundImage: product.imageUrl as ImageProvider<Object>,
                  radius: media.width * 0.2,
                ),
                SizedBox(height: media.height * 0.02),
                const Text(
                  'Descripción:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: media.height * 0.01),
                _buildDescription(product.description, media),
                SizedBox(height: media.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Precio:',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: media.width * 0.02),
                    Text(
                      '${product.price} USD',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                        fontSize: media.width * 0.04,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: media.width * 0.02),
                    Text(
                      product.peso,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                        fontSize: media.width * 0.04,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.height * 0.02),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDescription(dynamic description, Size media) {
  if (description is String) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: media.width * 0.02),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: media.width * 0.035,
          color: Colors.grey,
        ),
      ),
    );
  } else if (description is List<dynamic>) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: media.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: description.map((detailItem) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: media.height * 0.005),
            child: Text(
              detailItem,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: media.width * 0.035,
                color: Colors.grey,
              ),
            ),
          );
        }).toList(),
      ),
    );
  } else {
    return const Text(
      'Descripción no disponible',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: Colors.grey,
      ),
    );
  }
}
