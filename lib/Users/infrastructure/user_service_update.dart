import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class UserUpdate{
  final String baseUrl;

  UserUpdate(this.baseUrl);

  Future<Response> update(Map<String, dynamic> updatedFields) async {
    final url = Uri.parse('$baseUrl/user/update');
    final token = await TokenUser().getToken();

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedFields),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = jsonDecode(response.body);
      return Response(
        isSuccessful: true,
        userId: responseData['user_id'],
      );
    } else {
      return Response(
        isSuccessful: false,
        errorMessage: response.body,
      );
    }
  }
}

class Response {
  final bool isSuccessful;
  final String? userId;
  final String? errorMessage;

  Response({
    required this.isSuccessful,
    this.userId,
    this.errorMessage,
  });
}