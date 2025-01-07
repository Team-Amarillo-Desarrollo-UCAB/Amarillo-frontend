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
  bool isLoading = true;
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
        isLoading = false;
      });
    } catch (e) {
      print('Error obteniendo detalles de la orden: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Track orden'),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(), 
        ),
      );
    }
    final deliveryLatLng = LatLng(order.latitude, order.longitude);
    print(deliveryLatLng);
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
        mainAxisSize: MainAxisSize.min, 
        children: [
          Expanded(
            child: ListView(
              children: [
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
                                order.directionName,
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
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                            fit: FlexFit.loose,
                            child:Text(
                              "Orden #${order.orderId.substring(order.orderId.length - 4)}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                            ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Total: \$${order.totalAmount}",
                              style:
                                  TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  
                            ),
                          ],
                        ),
                       /* ElevatedButton(
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
                        ),*/
                      ],
                    ),
                  ),
                ),
                Divider(),
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
                                      position: deliveryLatLng),
                                },
                                polylines: {
                                  Polyline(
                                    polylineId: PolylineId('route'),
                                    points: [origin, deliveryLatLng],
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
