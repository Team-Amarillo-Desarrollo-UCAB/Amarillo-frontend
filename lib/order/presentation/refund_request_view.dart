import 'package:desarrollo_frontend/order/infrastructure/order_service_report_problem.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../common/infrastructure/base_url.dart';

class RefundRequestView extends StatefulWidget {
  final String orderId;

  RefundRequestView({required this.orderId});

  @override
  _RefundRequestViewState createState() => _RefundRequestViewState();
}

class _RefundRequestViewState extends State<RefundRequestView> {
  String? selectedProblem;
  final TextEditingController commentController = TextEditingController();
  final OrderServiceReportProblem orderService = OrderServiceReportProblem(BaseUrl().BASE_URL);

  Future<void> _submitRefundRequest() async {
    if (selectedProblem == null || commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, seleccione un problema y deje un comentario.'),
      ));
      return;
    }
    final String fullComment = '$selectedProblem: ${commentController.text}';
    try {
      final response = await orderService.reportProblem(widget.orderId, fullComment);

      if (response.isSuccessful) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Reporte enviado con éxito.'),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.errorMessage}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ocurrió un error, por favor intente nuevamente.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportar orden'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Elegir problema',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    value: selectedProblem,
                    hint: Text('Selecciona un problema'),
                    items: [
                      'Productos dañados o defectuosos',
                      'Error en el envío',
                      'Insatisfacción con el producto',
                      'Problemas de calidad',
                    ]
                        .map((problem) => DropdownMenuItem<String>(
                              value: problem,
                              child: Text(problem),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProblem = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      offset: Offset(0, 8),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 48,
                    ),
                  ),
                ),
                if (selectedProblem != null)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        selectedProblem = null;
                      });
                    },
                  ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 4,
              maxLength: 150,
              decoration: InputDecoration(
                hintText: 'Deja un comentario sobre el problema',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRefundRequest, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Reportar problema',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
