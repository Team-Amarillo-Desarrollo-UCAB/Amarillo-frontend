import 'dart:convert';

import 'package:desarrollo_frontend/Users/domain/notification.dart';
import 'package:desarrollo_frontend/Users/domain/notificationData.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class NotificationService{
  final String baseUrl;

  NotificationService(this.baseUrl);

  Future<List<NotificationDomain>> getNotification() async {
    final token = await TokenUser().getToken();
    try{
    final url = Uri.parse('$baseUrl/notifications/many');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    print(response.statusCode);
    if (response.statusCode == 200 ) {

    final List<dynamic> decodedData = json.decode(response.body);

    return decodedData.map((json) {
      final notifyData = NotificationData.fromJson(json);
      return NotificationDomain(
        title: notifyData.title,
        body: notifyData.body,
        id: notifyData.id,
        date: notifyData.date,
        userReaded: notifyData.userReaded,
      );
    }).toList();
  } else {
    throw Exception('Error al obtener las notificaciones');
  }
    }catch(e){
      throw Exception('Error al obtener las notificaciones: $e');
    }
  }
}