import 'package:flutter/material.dart';
import 'notificacion.dart';

class NotificationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            NotificationTile(
              title: 'Promociones',
              subtitle: 'Entérate de ofertas y promociones exclusivas',
              preferenceKey: 'promotions_notifications', 
              initialValue: true,
            ),
            NotificationTile(
              title: 'Novedades',
              subtitle: 'Descubre nuevos catálogos y productos',
              preferenceKey: 'new_catalog_notifications', 
              initialValue: true,
            ),
            NotificationTile(
              title: 'Notificarme por Correo',
              subtitle: 'Recibe notificaciones en tu correo-e.',
              preferenceKey: 'email_notifications', 
              initialValue: true,
            ),
            NotificationTile(
              title: 'Notificaciones Push',
              subtitle: 'Recibe notificaciones en tu teléfono.',
              preferenceKey: 'push_notifications', 
              initialValue: false,
            ),
          ],
        ),
      ),
    );
  }
}
