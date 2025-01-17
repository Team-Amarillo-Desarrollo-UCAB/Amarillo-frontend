
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../common/infrastructure/base_url.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final String baseUrl = BaseUrl().AMARILLO;
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications(String userToken) async {
    // Solicita permiso para mostrar notificaciones
    await _firebaseMessaging.requestPermission();

    // Obtiene el token de FCM
    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');

    // Envía el token FCM al servidor
    if (fCMToken != null) {
      await sendTokenToServer(fCMToken, userToken);
    }

    // Configura el handler para mensajes en segundo plano
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> sendTokenToServer(String fCMToken, String userToken) async {
    final url = Uri.parse('$baseUrl/notifications/savetoken');

    // Crea el cuerpo de la solicitud con el token FCM
    final body = json.encode({
      'token': fCMToken,
    });

    // Configura los encabezados, incluyendo el Bearer token
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken', // El token de usuario
    };

    try {
      // Realiza la solicitud POST al servidor
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Token enviado exitosamente');
      } else {
        print('Error al enviar token: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al enviar el token: $e');
    }
  }
}
