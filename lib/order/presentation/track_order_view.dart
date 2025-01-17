import 'dart:async';
import 'package:desarrollo_frontend/order/domain/order.dart';
import 'package:desarrollo_frontend/order/infrastructure/order_service_change_state.dart';
import 'package:desarrollo_frontend/order/infrastructure/order_service_search_by_id.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../common/infrastructure/base_url.dart';
import 'detailed_map_view.dart';

class TrackOrderView extends StatefulWidget {
  final String orderId;
  TrackOrderView({required this.orderId});

  @override
  _TrackOrderViewState createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  int currentStep = 0;
  final int totalSteps = 4;
  late Timer _timer;

  final LatLng origin = LatLng(10.491, -66.902);
  late Order order;
  bool isLoading = true;
  late final OrderServiceSearchById orderServiceSearchById;
  final OrderServiceChangeState orderServiceChangeState =
      OrderServiceChangeState(BaseUrl().BASE_URL);
      
  

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

       @override
  void initState() {
    super.initState();
    orderServiceSearchById = OrderServiceSearchById(BaseUrl().BASE_URL);
    _fetchOrderDetails();
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) async {
      await _fetchOrderDetails();
      currentStep = _getStepFromStatus(order.status);
    });
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final fetchedOrder = await orderServiceSearchById.getOrderById(widget.orderId);
      setState(() {
        order = fetchedOrder; 
        isLoading = false;
        currentStep = _getStepFromStatus(order.status);
      });
    } catch (e) {
      print('Error obteniendo detalles de la orden: $e');
    }
  }

  int _getStepFromStatus(String status) {
    switch (status) {
      case 'CREATED':
        return 0;
      case 'BEING PROCESSED':
        return 1;
      case 'SHIPPED':
        return 2;
      case 'DELIVERED':
        return 3;
      default:
        return 0;
    }
  }

  Future<void> _changeState(String orderId, String newState) async {
    try {
      
      await orderServiceChangeState.changeState(orderId, newState);

      setState(() {
        order.status = newState;
        currentStep = _getStepFromStatus(newState); 
      });
    } catch (e) {
      print('Error cambiando el estado: $e');
    }
  }

  @override
void dispose() {
  _timer.cancel();
  super.dispose();
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
    final orderStatusDetails = _getOrderStatusDetails(order.status);
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
                        Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: orderStatusDetails['backgroundColor'],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      orderStatusDetails['icon'],
                                      color: orderStatusDetails['iconColor'],
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      order.status,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,),
                                    ),
                                  ],
                                ),
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
                        onStepTapped: (int step) async {
                          if (step > currentStep) {
                            final newState = _getStateFromStep(step);
                            if (step <= currentStep) {
                              await _changeState(order.orderId, newState);
                            }
                          }
                          setState(() {
                            currentStep = step;
                            _fetchOrderDetails();
                          });
                        },
                        onStepContinue: () {
                          if (currentStep < totalSteps - 1 && currentStep < _getStepFromStatus(order.status)) {
                            setState(() {
                              currentStep += 1;
                              _fetchOrderDetails();
                            });
                          }
                        },
                        onStepCancel: () {
                          if (currentStep > 0) {
                            setState(() {
                              currentStep -= 1;
                            });
                          }
                        },
                        controlsBuilder: (BuildContext context, ControlsDetails details) {
                          return SizedBox.shrink();
                        },
                        steps: [
                          Step(
                            title: Text('Orden creada'),
                            content: Container(),
                            isActive: currentStep >= 0,
                            state: currentStep > 0
                                ? StepState.complete
                                :  currentStep == 0
                                      ? StepState.indexed
                                      : StepState.disabled,
                          ),
                          Step(
                            title: Text('Items procesados'),
                            content: Container(),
                            isActive: currentStep >= 1,
                            state: currentStep > 1
                                ? StepState.complete
                                : currentStep == 0
                                  ? StepState.indexed
                                  : StepState.disabled,
                          ),
                          Step(
                          title: Text('Orden en camino'),
                          content: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: GoogleMap(
                                  onMapCreated: (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                  initialCameraPosition: CameraPosition(
                                    target: origin,
                                    zoom: 14.0,
                                  ),
                                  markers: {
                                    Marker(markerId: MarkerId('origin'), position: origin),
                                    Marker(markerId: MarkerId('destination'), position: deliveryLatLng),
                                  },
                                  polylines: {
                                    Polyline(
                                      polylineId: PolylineId('route'),
                                      points: [origin, deliveryLatLng],
                                      color: Colors.blue,
                                      width: 3,
                                    ),
                                  },
                                  scrollGesturesEnabled: true, 
                                  zoomGesturesEnabled: false,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailedMapView(
                                          origin: origin,
                                          destination: deliveryLatLng,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Ver mapa a detalle'),
                                ),
                              ),
                            ],
                          ),
                          isActive: currentStep >= 2,
                          state: currentStep > 2 ? StepState.complete : StepState.indexed,
                        ),
                          Step(
                            title: Text('Orden entregada'),
                            content: Container(),
                            isActive: currentStep >= 3,
                            state: currentStep > 3
                                ? StepState.complete
                                : currentStep == 0
                                    ? StepState.indexed
                                    : StepState.disabled,
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

  String _getStateFromStep(int step) {
    switch (step) {
      case 0:
        return 'CREATED';
      case 1:
        return 'BEING PROCESSED';
      case 2:
        return 'SHIPPED';
      case 3:
        return 'DELIVERED';
      default:
        return 'CREATED';
    }
  }
  Map<String, dynamic> _getOrderStatusDetails(String status) {
    switch (status) {
      case "CREATED" :
        return {
          "icon": Icons.check_circle,
          "iconColor": Colors.green,
          "textColor": Colors.green,
          "backgroundColor": Colors.green[100],
        };
      case "DELIVERED":
        return {
          "icon": Icons.check_circle,
          "iconColor": Colors.green,
          "textColor": Colors.green,
          "backgroundColor": Colors.green[100],
        };
      case "SHIPPED":
        return {
          "icon": Icons.access_time,
          "iconColor": Colors.orange,
          "textColor": Colors.orange,
          "backgroundColor": Colors.orange[100],
        };
      case "CANCELLED":
        return {
          "icon": Icons.cancel,
          "iconColor": Colors.red,
          "textColor": Colors.red,
          "backgroundColor": Colors.red[100],
        };
        case "BEING PROCESSED":
        return {
          "icon": Icons.access_time,
          "iconColor": Colors.orange,
          "textColor": Colors.orange,
          "backgroundColor": Colors.orange[100],
        };
      default:
        return {
          "icon": Icons.help,
          "iconColor": Colors.grey,
          "textColor": Colors.grey,
          "backgroundColor": Colors.grey[100],
        };
    }
  }
}
