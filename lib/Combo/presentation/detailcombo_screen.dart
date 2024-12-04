import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Producto/domain/popular_product.dart';
import 'package:desarrollo_frontend/Producto/infrastructure/product_service_search_by_id.dart';
import 'package:flutter/material.dart';

void showDetailComboDialog(BuildContext context, Combo combo,
    VoidCallback onAdd, ProductServiceSearchbyId productService) {
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
                  combo.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    fontSize: media.width * 0.05,
                  ),
                ),
                SizedBox(height: media.height * 0.02),
                CircleAvatar(
                  backgroundImage: combo.images[0] as ImageProvider<Object>,
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
                    combo.description,
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
                const Text(
                  'Lista de Productos:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: media.width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: combo.productId.map((productId) {
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
                      '${combo.price} USD',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                        fontSize: media.width * 0.04,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: media.width * 0.02),
                    Text(
                      combo.peso,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                        fontSize: media.width * 0.04,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.height * 0.02),
                ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Agregar al carrito',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      fontSize: media.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
