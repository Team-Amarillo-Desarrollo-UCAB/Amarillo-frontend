import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:flutter/material.dart';

import '../../common/presentation/color_extension.dart';

class DireccionWidget extends StatefulWidget {
  final Direccion direccion;
  final VoidCallback onRemove;
  final VoidCallback onSelect;
  const DireccionWidget({
    super.key,
    required this.direccion,
    required this.onRemove,
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
        backgroundColor: TColor.primary,
        child: CircleAvatar(
          radius: 12,
          backgroundColor:
              widget.direccion.isSelected ? TColor.primary : TColor.white,
        ),
      ),
      title: Text(
        widget.direccion.nombre,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        widget.direccion.direccionCompleta,
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: Colors.grey),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: TColor.primary),
        onPressed: widget.onRemove,
      ),
      onTap: widget.onSelect,
    );
  }
}
