import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddDireccionDialog extends StatefulWidget {
  final Function(Direccion) onAdd;
  const AddDireccionDialog({super.key, required this.onAdd});
  @override
  AddDireccionDialogState createState() => AddDireccionDialogState();
}

class AddDireccionDialogState extends State<AddDireccionDialog> {
  final TextEditingController _nameController = TextEditingController();
  LatLng? _selectedPosition;
  String _selectedAddress = '';
  void _selectCoordinates() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MapScreen(
        onTap: (position) {
          setState(() {
            _selectedPosition = position;
          });
        },
      ),
    ));
    if (result != null) {
      _selectedPosition = result;
      _getAddressFromCoordinates(
          _selectedPosition!.latitude, _selectedPosition!.longitude);
    }
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    final apiKey = 'pk.d24036d884f990ee74f8b4a9f2e46fbe';
    final url =
        'https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$latitude&lon=$longitude&format=json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _selectedAddress = data['display_name'];
      });
    } else {
      print('Failed to get address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Añadir nueva dirección'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre de la dirección'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _selectCoordinates,
            child: Text('Obtener coordenadas'),
          ),
          if (_selectedPosition != null)
            Column(
              children: [
                Text('Latitud: ${_selectedPosition!.latitude}'),
                Text('Longitud: ${_selectedPosition!.longitude}'),
              ],
            ),
          if (_selectedAddress.isNotEmpty) Text('Dirección: $_selectedAddress'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final nombre = _nameController.text;
            if (nombre.isNotEmpty && _selectedAddress.isNotEmpty) {
              final nuevaDireccion = Direccion(
                nombre: nombre,
                direccionCompleta: _selectedAddress,
                latitude: _selectedPosition!.latitude,
                longitude: _selectedPosition!.longitude,
                isSelected: false,
              );
              widget.onAdd(nuevaDireccion);
              Navigator.of(context).pop();
            }
          },
          child: Text('Añadir'),
        ),
      ],
    );
  }
}

class MapScreen extends StatelessWidget {
  final Function(LatLng) onTap;
  MapScreen({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una ubicación'),
      ),
      body: GoogleMap(
        onTap: onTap,
        initialCameraPosition: CameraPosition(
          target: LatLng(10.464898, -66.953192),
          zoom: 15,
        ),
        markers: {
          if (onTap != null)
            Marker(
              markerId: MarkerId('selected-location'),
              position: LatLng(10.464898, -66.953192),
            ),
        },
      ),
    );
  }
}
