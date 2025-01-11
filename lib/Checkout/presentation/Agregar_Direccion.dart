import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as loc;

class AddDireccionDialog extends StatefulWidget {
  final Function(Direccion) onAdd;
  const AddDireccionDialog({super.key, required this.onAdd});
  @override
  AddDireccionDialogState createState() => AddDireccionDialogState();
}

class AddDireccionDialogState extends State<AddDireccionDialog> {
  final TextEditingController _nameController = TextEditingController();
  loc.LocationData? _currentLocation;
  String _selectedAddress = '';
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
    _currentLocation = await location.getLocation();
    _updateAddress(_currentLocation!.latitude!, _currentLocation!.longitude!);
  }

  Future<void> _updateAddress(double latitude, double longitude) async {
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      geocoding.Placemark place = placemarks[0];
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
          SizedBox(height: 16),
          if (_currentLocation != null)
            Column(
              children: [
                Text('Latitud: ${_currentLocation!.latitude}'),
                Text('Longitud: ${_currentLocation!.longitude}'),
                Text('Dirección: $_selectedAddress'),
              ],
            )
          else
            CircularProgressIndicator(),
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
                latitude: _currentLocation!.latitude!,
                longitude: _currentLocation!.longitude!,
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
