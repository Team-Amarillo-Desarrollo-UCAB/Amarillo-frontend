// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'credentials.dart';

// class ChatBotScreen extends StatefulWidget {
//   @override
//   _ChatBotScreenState createState() => _ChatBotScreenState();
// }

// class _ChatBotScreenState extends State<ChatBotScreen> {
//   final TextEditingController _messageController = TextEditingController(); // Controlador del TextField
//   List<Map<String, String>> messages = [];

//   // final String backendUrl = 'https://orangeteam-deliverybackend-production.up.railway.app/product/many'; //Orange
//   final String backendUrl = 'https://amarillo-backend-production.up.railway.app/product/many';

//   final String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText';



import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // Importa el paquete oficial

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> messages = [];

  final String backendUrl = 'https://amarillo-backend-production.up.railway.app/product/many';

  // Configura el modelo y la clave API
  final String apiKey = 'AIzaSyB8fMhva1VukHbLzM6cWHl8Ie_XCEnP0sU';
  late GenerativeModel model= GenerativeModel(
      model: 'gemini-pro', // El modelo de Google Generative AI
      apiKey: apiKey,
    );

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(
      model: 'gemini-pro', // El modelo de Google Generative AI
      apiKey: apiKey,
    );
  }

  void sendMessage(String userMessage) async {
    setState(() {
      messages.add({"sender": "user", "text": userMessage});
    });

    // Llama al backend para obtener la lista de productos
    final productsResponse = await http.get(Uri.parse(backendUrl), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMyOTMwODJlLWQ4M2EtNDFlOC1hMDVlLTgzZDAwODRkNzMzYiIsImlhdCI6MTczNjg2OTg0MSwiZXhwIjoxNzM2OTU2MjQxfQ.7TaW0gvUaRWGkZbZdGYvIvqesDe2rCzzHL4spVNjDhA',
    });

    if (productsResponse.statusCode != 200) {
      setState(() {
        messages.add({"sender": "bot", "text": "Error al obtener la lista de productos."});
      });
      return;
    }

    // Decodifica la lista de productos
    final List products = jsonDecode(productsResponse.body);

    // Llama al modelo de Generative AI para filtrar los productos
    final filteredProducts = await filterProducts(userMessage, products);

    // Construye el mensaje con los productos relevantes
    String botResponse;
    if (filteredProducts.isEmpty) {
      botResponse = "No encontré productos que coincidan con tu solicitud.";
    } else {
      botResponse = "Aquí tienes algunas sugerencias:\n";
      botResponse += filteredProducts
          .take(10)
          .map((p) => "${p['name']} - \$${p['price']}")
          .join("\n");
    }

    // Agrega la respuesta del bot a la conversación
    setState(() {
      messages.add({"sender": "bot", "text": botResponse});
    });
  }

  Future<List> filterProducts(String userMessage, List products) async {
  // Construye el prompt basado en el mensaje del usuario y la lista de productos
  print("Aquí hay una lista de productos:${products.map((p) => "${p['name']}").join(', ')}");
  // final prompt = 'El usuario dijo: "$userMessage". Aquí hay una lista de productos:${products.map((p) => "${p['name']}").join(', ')}.Selecciona los productos que sean relevantes para la solicitud del usuario y devuélvelos como una lista JSON con solo el nombre y el precio.';
  final prompt = 'Hola';
  // Genera el contenido con el modelo
  final responses = model.generateContentStream([Content.text(prompt)]);
  // Procesa las respuestas del modelo
  await for (final response in responses) {
    print(response.text);
    try {
      if (response.text != null) {
        print("Respuesta recibida del modelo: ${response.text}");

        // Verificar si el texto es un JSON válido antes de intentar decodificarlo
        if (response.text!.trim().startsWith('[') && response.text!.trim().endsWith(']')) {
          return jsonDecode(response.text!); // Decodifica el JSON devuelto
        } else {
          print("El texto devuelto no es un JSON válido: ${response.text}");
          return [];
        }
      } else {
        print("La respuesta del modelo es nula.");
        return [];
      }
    } catch (e) {
      print('Error al procesar la respuesta del modelo: $e');
      return [];
    }
  }

  // Si no se reciben respuestas del modelo, retorna una lista vacía
  return [];
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot con Gemini AI')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg["sender"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: msg["sender"] == "user"
                          ? Colors.blue[100]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(msg["text"]!),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        sendMessage(value.trim());
                        _messageController.clear();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Escribe tu mensaje aquí...",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final userMessage = _messageController.text.trim();
                    if (userMessage.isNotEmpty) {
                      sendMessage(userMessage);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
