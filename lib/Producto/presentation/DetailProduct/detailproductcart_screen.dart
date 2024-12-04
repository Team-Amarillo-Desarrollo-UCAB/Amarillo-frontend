import 'package:desarrollo_frontend/Carrito/domain/cart_item.dart';
import 'package:desarrollo_frontend/Producto/domain/popular_product.dart';
import 'package:desarrollo_frontend/Producto/infrastructure/product_service_search_by_id.dart';
import 'package:flutter/material.dart';

void showDetailCartItemDialog(BuildContext context, CartItem product,
    ProductServiceSearchbyId productService) {
  print('productID: ${product.productId}');
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: media.width * 0.02),
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: media.width * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: media.height * 0.02),
                if (product.productId != null) ...[
                  const Text(
                    'Lista de Productos:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: media.width * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: product.productId!.map((productId) {
                        return FutureBuilder<Product>(
                          future: productService.getProductById(productId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.name,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: media.width * 0.035,
                                  color: Colors.grey,
                                ),
                              );
                            } else {
                              return Text('Producto no encontrado');
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
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
