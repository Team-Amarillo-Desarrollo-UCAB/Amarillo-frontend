import 'dart:async';
import 'package:desarrollo_frontend/order/domain/order.dart';
import 'package:desarrollo_frontend/order/infrastructure/order_service_search_by_id.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../common/infrastructure/base_url.dart';

class TrackOrderView extends StatefulWidget {
  final String orderId;
  TrackOrderView({required this.orderId});

  @override
  _TrackOrderViewState createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  int currentStep = 0;
  final LatLng origin = LatLng(10.491, -66.902);
  late Order order;
  final LatLng destination = LatLng(10.496, -66.845);
  final String deliveryLocation = "Universidad Católica Andrés Bello";
  final OrderServiceSearchById orderServiceSearchById =
      OrderServiceSearchById(BaseUrl().BASE_URL);

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

       @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final fetchedOrder = await orderServiceSearchById.getOrderById(widget.orderId);
      setState(() {
        order = fetchedOrder; 
      });
    } catch (e) {
      print('Error obteniendo detalles de la orden: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track orden'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Card con la información de entrega
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: const Color(0xFFFF7622), width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16),
                            SizedBox(width: 8),
                            Text(
                              order.creationDate,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_pin, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                deliveryLocation,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Card con información del repartidor
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: const Color(0xFFFF7622), width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        // Imagen circular del delivery
                        ClipOval(
                          child: Image.asset(
                            'assets/img/perfil.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CARLOS ALONZO",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF7622),
                              ),
                            ),
                            Text(
                              "Tu delivery",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                // Card con información de la orden
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: const Color(0xFFFF7622), width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Orden #${order.orderId}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Total: \$${order.totalAmount}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                // Stepper con seguimiento de la orden
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tiempo estimado: 15 minutos',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Stepper(
                        currentStep: currentStep,
                        onStepTapped: (index) {
                          setState(() {
                            currentStep = index;
                          });
                        },
                        steps: [
                          Step(
                            title: Text('Orden creada'),
                            content: Container(),
                            isActive: currentStep >= 0,
                            state: currentStep > 0
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                          Step(
                            title: Text('Items procesados'),
                            content: Container(),
                            isActive: currentStep >= 1,
                            state: currentStep > 1
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                          Step(
                            title: Text('Orden en camino'),
                            content: SizedBox(
                              height: 200,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                initialCameraPosition: CameraPosition(
                                  target: origin,
                                  zoom: 14.0,
                                ),
                                markers: {
                                  Marker(
                                      markerId: MarkerId('origin'),
                                      position: origin),
                                  Marker(
                                      markerId: MarkerId('destination'),
                                      position: destination),
                                },
                                polylines: {
                                  Polyline(
                                    polylineId: PolylineId('route'),
                                    points: [origin, destination],
                                    color: Colors.blue,
                                    width: 5,
                                  ),
                                },
                                scrollGesturesEnabled: true,
                                zoomGesturesEnabled: true,
                                rotateGesturesEnabled: true,
                                tiltGesturesEnabled: true,
                              ),
                            ),
                            isActive: currentStep >= 2,
                            state: currentStep > 2
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                          Step(
                            title: Text('Orden entregada'),
                            content: Container(),
                            isActive: currentStep >= 3,
                            state: currentStep > 3
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
