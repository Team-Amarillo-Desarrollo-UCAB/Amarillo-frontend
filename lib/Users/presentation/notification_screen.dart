import 'package:desarrollo_frontend/Users/domain/notification.dart';
import 'package:desarrollo_frontend/Users/infrastructure/notification_service.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List<NotificationDomain> notifications = [];
  bool isLoading = true;
  final NotificationService _notificacionService = NotificationService(BaseUrl().BASE_URL);

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      List<NotificationDomain> fetchedOrders = await _notificacionService.getNotification();
      setState(() {
        notifications = fetchedOrders;
        isLoading = false; // Se actualiza después de cargar los datos
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener notificaciones: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar
      (
        backgroundColor: TColor.secondary,
        title: Text('Notificaciones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('No hay notificaciones disponibles.'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    SizedBox(height: 8);
                    return Card(
                      color: notification.userReaded ? Colors.grey[200] : Colors.white,
                      child: ListTile(
                        leading: Icon(
                          notification.userReaded
                              ? Icons.notifications_off
                              : Icons.notifications_active,
                          color: notification.userReaded ? Colors.grey : TColor.primary,
                        ),
                        title: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.userReaded ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification.body),
                            SizedBox(height: 5),
                            Text(
                              "Fecha: ${notification.date.toLocal()}",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Notificación seleccionada: ${notification.title}',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
