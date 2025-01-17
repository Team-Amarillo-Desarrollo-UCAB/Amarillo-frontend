import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:desarrollo_frontend/Checkout/presentation/direccion_widget.dart';
import 'package:flutter/material.dart';

import '../../common/presentation/color_extension.dart';

class ListaDirecciones extends StatefulWidget {
  final List<Direccion> direcciones;
  final VoidCallback onAddDireccion;
  final Function(Direccion) onRemoveDireccion;
  final Function(Direccion) onSelectDireccion;

  const ListaDirecciones({
    super.key,
    required this.direcciones,
    required this.onAddDireccion,
    required this.onRemoveDireccion,
    required this.onSelectDireccion,
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
              onRemove: () {
                widget.onRemoveDireccion(direccion);
              },
              onSelect: () {
                setState(() {
                  for (var d in widget.direcciones) {
                    d.isSelected = false;
                  }
                  direccion.isSelected = true;
                });
                widget.onSelectDireccion(direccion);
              },
            )),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: widget.onAddDireccion,
          icon: Icon(
            Icons.add,
            color: TColor.primary,
          ),
          label: Text(
            'Añadir nueva dirección',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: TColor.primary),
          ),
        ),
      ],
    );
  }
}
