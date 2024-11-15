import 'package:desarrollo_frontend/domain/Checkout/direccion.dart';
import 'package:desarrollo_frontend/domain/Checkout/direcciones_screen.dart';
import 'package:desarrollo_frontend/domain/Checkout/fecha_hora_widget.dart';
import 'package:desarrollo_frontend/domain/Checkout/metodo_de_pago_widget.dart';
import 'package:desarrollo_frontend/domain/Checkout/pie_pagina_widget.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final int totalItems;
  final double totalPrice;
  const CheckoutScreen(
      {super.key, required this.totalItems, required this.totalPrice});

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final List<Direccion> direcciones = [
    Direccion(
      nombre: 'Home "Fiscal"',
      direccionCompleta: 'Venezuela, Caracas...',
    ),
    Direccion(nombre: 'Oficina', direccionCompleta: 'Venezuela, Caracas...'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Envía a',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            ListaDirecciones(
              direcciones: direcciones,
              onAddDireccion: () {
                // Lógica para añadir una nueva dirección (lo implementaras más adelante)
              },
            ),
            const SizedBox(height: 10),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Ingrese la fecha y hora de preferencial',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ), // Add spacing above the selector
            const FechaHoraSelector(),
            const SizedBox(height: 10),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Seleccione el metodo de pago',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const MetodosDePago(),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ResumenPedido(
            totalItems: widget.totalItems, totalPrice: widget.totalPrice),
      ),
    );
  }
}
