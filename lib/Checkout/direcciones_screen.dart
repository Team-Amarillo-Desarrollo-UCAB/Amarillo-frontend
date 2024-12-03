import 'package:desarrollo_frontend/Checkout/direccion.dart';
import 'package:desarrollo_frontend/Checkout/direccion_widget.dart';
import 'package:flutter/material.dart';

class ListaDirecciones extends StatefulWidget {
  final List<Direccion> direcciones;
  final VoidCallback onAddDireccion;

  const ListaDirecciones({
    super.key,
    required this.direcciones,
    required this.onAddDireccion,
  });

  @override
  ListaDireccionesState createState() => ListaDireccionesState();
}

class ListaDireccionesState extends State<ListaDirecciones> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.direcciones.map((direccion) => DireccionWidget(
              direccion: direccion,
              onEdit: () {
                // Lógica para editar la dirección
              },
              onSelect: () {
                // Lógica para seleccionar la dirección
                setState(() {
                  for (var d in widget.direcciones) {
                    d.isSelected = false;
                  }
                  direccion.isSelected = true;
                });
              },
            )),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: widget.onAddDireccion,
          icon: const Icon(
            Icons.add,
            color: Colors.orange,
          ),
          label: const Text(
            'Añadir nueva dirección',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.orange),
          ),
        ),
      ],
    );
  }
}
