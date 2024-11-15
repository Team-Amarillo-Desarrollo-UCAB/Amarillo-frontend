import 'package:desarrollo_frontend/domain/Checkout/direccion.dart';
import 'package:flutter/material.dart';

class DireccionWidget extends StatefulWidget {
  final Direccion direccion;
  final VoidCallback onEdit;
  final VoidCallback onSelect;

  const DireccionWidget({
    super.key,
    required this.direccion,
    required this.onEdit,
    required this.onSelect,
  });

  @override
  DireccionWidgetState createState() => DireccionWidgetState();
}

class DireccionWidgetState extends State<DireccionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.orange,
        child: CircleAvatar(
          radius: 12,
          backgroundColor:
              widget.direccion.isSelected ? Colors.orange : Colors.white,
        ),
      ),
      title: Text(
        widget.direccion.nombre,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        widget.direccion.direccionCompleta,
        style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: Colors.grey),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.orange),
        onPressed: widget.onEdit,
      ),
      onTap: widget.onSelect,
    );
  }
}
