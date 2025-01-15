import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class OrderServiceReportProblem {
  final String baseUrl;

  OrderServiceReportProblem(this.baseUrl);

  Future<ReportResponse> reportProblem(String orderId, String text) async {
    final url = Uri.parse('$baseUrl/order/report/$orderId');
    final token = await TokenUser().getToken();


    final body = {
      "texto": text,
    };

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = jsonDecode(response.body);
      return ReportResponse(
        isSuccessful: true,
        orderId: responseData['order_id'],
        reportId: responseData['id_reporte'],
      );
    } else {
      return ReportResponse(
        isSuccessful: false,
        errorMessage: response.body,
      );
    }
  }
}

class ReportResponse {
  final bool isSuccessful;
  final String? orderId;
  final String? reportId;
  final String? errorMessage;

  ReportResponse({
    required this.isSuccessful,
    this.orderId,
    this.reportId,
    this.errorMessage,
  });
}
