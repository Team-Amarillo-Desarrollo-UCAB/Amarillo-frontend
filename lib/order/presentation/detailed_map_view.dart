import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DetailedMapView extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;

  const DetailedMapView({
    Key? key,
    required this.origin,
    required this.destination,
  }) : super(key: key);

  @override
  _DetailedMapViewState createState() => _DetailedMapViewState();
}

class _DetailedMapViewState extends State<DetailedMapView> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng currentPosition;
  List<LatLng> routePoints = [];
  int routeIndex = 0;
  late Timer movementTimer;

  final String apiKey =
      '5b3ce3597851110001cf62481239918cf053437d8c9ad46a0fd38846';

  @override
  void initState() {
    super.initState();
    currentPosition = widget.origin;
    _getRoute(widget.origin, widget.destination);
  }

  @override
  void dispose() {
    movementTimer.cancel();
    super.dispose();
  }

  Future<void> _getRoute(LatLng origin, LatLng destination) async {
    final String url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${origin.longitude},${origin.latitude}&end=${destination.longitude},${destination.latitude}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routeGeometry = data['features'][0]['geometry']['coordinates'];

      List<LatLng> points = [];
      for (var coord in routeGeometry) {
        points.add(LatLng(coord[1], coord[0]));
      }

      setState(() {
        routePoints = points;
        movementTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (routeIndex < routePoints.length - 1) {
            setState(() {
              routeIndex++;
              currentPosition = routePoints[routeIndex];
              // Verifica si el delivery ha llegado a su destino
              if (_hasArrivedAtDestination(
                  currentPosition, widget.destination)) {
                timer.cancel();
                _showArrivalDialog(
                    context); // Mostrar el pop-up al llegar al destino
              }
            });
          } else {
            timer.cancel();
          }
        });
      });
    } else {
      print("Error fetching route: ${response.statusCode}");
    }
  }

  bool _hasArrivedAtDestination(LatLng current, LatLng destination) {
    const double threshold =
        0.0002; // Aumentamos la tolerancia de la comparación
    return (current.latitude - destination.latitude).abs() < threshold &&
        (current.longitude - destination.longitude).abs() < threshold;
  }

  // Función para mostrar el pop-up
  void _showArrivalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¡Entrega Completa!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          content: Text('¡Su delivery ya ha llegado!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa detallado',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: widget.origin,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('currentPosition'),
            position: currentPosition,
          ),
          Marker(
            markerId: MarkerId('destination'),
            position: widget.destination,
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: routePoints,
            color: Colors.blue,
            width: 5,
          ),
        },
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
      ),
    );
  }
}
