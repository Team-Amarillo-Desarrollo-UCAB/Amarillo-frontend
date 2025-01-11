import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class AddDireccionDialog extends StatefulWidget {
  final Function(Direccion) onAdd;
  const AddDireccionDialog({super.key, required this.onAdd});
  @override
  AddDireccionDialogState createState() => AddDireccionDialogState();
}

class AddDireccionDialogState extends State<AddDireccionDialog> {
  final TextEditingController _nameController = TextEditingController();
  LatLng _selectedPosition = LatLng(10.464898, -66.953192);
  String _selectedAddress = '';
  void _onMapTap(LatLng position) async {
    setState(() {
      _selectedPosition = position;
    });
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        _selectedAddress =
            '${place.street}, ${place.locality}, ${place.country}';
      });
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
          SizedBox(
            width: double.infinity,
            height: 300,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {},
              initialCameraPosition: CameraPosition(
                target: _selectedPosition,
                zoom: 15,
              ),
              onTap: _onMapTap,
              markers: {
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: _selectedPosition,
                ),
              },
            ),
          ),
          SizedBox(height: 8),
          Text('Dirección: $_selectedAddress'),
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
                latitude: _selectedPosition.latitude,
                longitude: _selectedPosition.longitude,
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
