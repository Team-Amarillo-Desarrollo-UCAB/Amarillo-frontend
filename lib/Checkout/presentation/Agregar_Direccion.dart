import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
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
        onLocationSelected: (position, address) {
          Navigator.of(context).pop({
            'position': position,
            'address': address,
          });
        },
      ),
    ));

    if (result != null) {
      setState(() {
        _selectedPosition = result['position'];
        _selectedAddress = result['address'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Añadir nueva dirección',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: 'Nombre de la dirección',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
          SizedBox(height: 16),
          ElevatedButton(
              onPressed: _selectCoordinates,
              child: Text('Seleccionar ubicación en el mapa',
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))),
          SizedBox(height: 16),
          if (_selectedPosition != null)
            Column(
              children: [
                Text('Latitud: ${_selectedPosition!.latitude}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                SizedBox(height: 10),
                Text('Longitud: ${_selectedPosition!.longitude}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ],
            ),
          SizedBox(height: 16),
          if (_selectedAddress.isNotEmpty)
            Text('Dirección: $_selectedAddress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar',
              style: TextStyle(
                color: TColor.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
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
          child: Text('Añadir',
              style: TextStyle(
                color: TColor.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
        ),
      ],
    );
  }
}

class MapScreen extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;
  MapScreen({required this.onLocationSelected});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  LatLng _selectedPosition = LatLng(10.464898, -66.953192);
  String _selectedAddress = '';

  Future<void> _searchLocation(String query) async {
    final apiKey = 'pk.d24036d884f990ee74f8b4a9f2e46fbe';
    final url =
        'https://us1.locationiq.com/v1/autocomplete.php?key=$apiKey&q=$query&countrycodes=ve&format=json';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final firstResult = data[0];
        final latitude = double.parse(firstResult['lat']);
        final longitude = double.parse(firstResult['lon']);
        final address = firstResult['display_name'];

        setState(() {
          _selectedPosition = LatLng(latitude, longitude);
          _selectedAddress = address;
        });

        _mapController.animateCamera(
          CameraUpdate.newLatLng(_selectedPosition),
        );
      }
    } else {
      print('Error al buscar la ubicación');
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
      print('Error al obtener la dirección');
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Selecciona una ubicación',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar ubicación...',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _searchLocation(_searchController.text),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ),
    ),
    body: Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
          },
          onTap: (position) async {
            setState(() {
              _selectedPosition = position;
            });
            await _getAddressFromCoordinates(
                position.latitude, position.longitude);
          },
          initialCameraPosition: CameraPosition(
            target: _selectedPosition,
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: MarkerId('selected-location'),
              position: _selectedPosition,
            ),
          },
        ),
        Positioned(
          bottom: 25,
          left: 16, 
          child: FloatingActionButton(
            onPressed: () {
              widget.onLocationSelected(_selectedPosition, _selectedAddress);
            },
            child: Icon(Icons.check),
          ),
        ),
      ],
    ),
  );
  }
}