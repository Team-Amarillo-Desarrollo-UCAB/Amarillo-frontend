// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;

// // import 'credentials.dart';

// // class ChatBotScreen extends StatefulWidget {
// //   @override
// //   _ChatBotScreenState createState() => _ChatBotScreenState();
// // }

// // class _ChatBotScreenState extends State<ChatBotScreen> {
// //   final TextEditingController _messageController = TextEditingController(); // Controlador del TextField
// //   List<Map<String, String>> messages = [];

// //   // final String backendUrl = 'https://orangeteam-deliverybackend-production.up.railway.app/product/many'; //Orange
// //   final String backendUrl = 'https://amarillo-backend-production.up.railway.app/product/many';

// //   final String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText';



// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart'; // Importa el paquete oficial

// class ChatBotScreen extends StatefulWidget {
//   @override
//   _ChatBotScreenState createState() => _ChatBotScreenState();
// }

// class _ChatBotScreenState extends State<ChatBotScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   List<Map<String, String>> messages = [];

//   final String backendUrl = 'https://amarillo-backend-production.up.railway.app/product/many';

//   // Configura el modelo y la clave API
//   final String apiKey = 'AIzaSyB8fMhva1VukHbLzM6cWHl8Ie_XCEnP0sU';
//   late GenerativeModel model= GenerativeModel(
//       model: 'gemini-pro', // El modelo de Google Generative AI
//       apiKey: apiKey,
//     );

//   @override
//   void initState() {
//     super.initState();
//     model = GenerativeModel(
//       model: 'gemini-pro', // El modelo de Google Generative AI
//       apiKey: apiKey,
//     );
//   }

//   void sendMessage(String userMessage) async {
//     setState(() {
//       messages.add({"sender": "user", "text": userMessage});
//     });

//     // Llama al backend para obtener la lista de productos
//     final productsResponse = await http.get(Uri.parse(backendUrl), headers: {
//       'Authorization':
//           'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMyOTMwODJlLWQ4M2EtNDFlOC1hMDVlLTgzZDAwODRkNzMzYiIsImlhdCI6MTczNjk2MTcyOCwiZXhwIjoxNzM3MDQ4MTI4fQ.BOwr9QtDcykmgJ_sBuvb_F7TQHYXR8KUuFlSaJtiRt4',
//     });

//     if (productsResponse.statusCode != 200) {
//       setState(() {
//         messages.add({"sender": "bot", "text": "Error al obtener la lista de productos."});
//       });
//       return;
//     }

//     // Decodifica la lista de productos
//     final List products = jsonDecode(productsResponse.body);
//     final prompt =
//       'El usuario dijo: "$userMessage". Aquí hay una lista de productos:${products.map((p) => "${p['name']}").join(', ')}.Selecciona los productos que sean relevantes para la solicitud del usuario.';

//     // Llama al modelo de Generative AI para filtrar los productos
    

//     // Agrega la respuesta del bot a la conversación
//     setState(() {
//       messages.add({"sender": "bot", "text": botResponse});
//     });
//   }


// Future<List> filterProducts(String userMessage, List products) async {
//   // Construye el prompt basado en el mensaje del usuario y la lista de productos
//   print("Aquí hay una lista de productos:${products.map((p) => "${p['name']}").join(', ')}");
//   final prompt =
//       'El usuario dijo: "$userMessage". Aquí hay una lista de productos:${products.map((p) => "${p['name']}").join(', ')}.Selecciona los productos que sean relevantes para la solicitud del usuario.';
//   final responses = model.sendMessage([Content.text(prompt)]);
//   await for (final response in responses) {
//     print("Respuesta recibida del modelo: ${response.text}");
//     try {
//       if (response.text != null) {
//         // Limpia el texto recibido
//         String cleanText = response.text!.trim();

//         // Elimina bloques de código como ```json y ``` si están presentes
//         if (cleanText.startsWith('```json')) {
//           cleanText = cleanText.replaceFirst('```json', '').trim();
//         }
//         if (cleanText.endsWith('```')) {
//           cleanText = cleanText.replaceFirst('```', '').trim();
//         }

//         // Verifica si el texto limpio es un JSON válido antes de intentar decodificarlo
//         if (cleanText.startsWith('[') ) { //&& cleanText.endsWith(']')
//           return jsonDecode(cleanText); // Decodifica el JSON limpio
//         } else {
//           print("El texto devuelto no es un JSON válido: $cleanText");
//           return [];
//         }
//       } else {
//         print("La respuesta del modelo es nula.");
//         return [];
//       }
//     } catch (e) {
//       print('Error al procesar la respuesta del modelo: $e');
//       return [];
//     }
    
//   }
//   return[];
// }




//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chatbot con Gemini AI')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[index];
//                 return Align(
//                   alignment: msg["sender"] == "user"
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   child: Container(
//                     margin: EdgeInsets.all(8.0),
//                     padding: EdgeInsets.all(12.0),
//                     decoration: BoxDecoration(
//                       color: msg["sender"] == "user"
//                           ? Colors.blue[100]
//                           : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Text(msg["text"]!),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     onSubmitted: (value) {
//                       if (value.trim().isNotEmpty) {
//                         sendMessage(value.trim());
//                         _messageController.clear();
//                       }
//                     },
//                     decoration: InputDecoration(
//                       hintText: "Escribe tu mensaje aquí...",
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     final userMessage = _messageController.text.trim();
//                     if (userMessage.isNotEmpty) {
//                       sendMessage(userMessage);
//                       _messageController.clear();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:google_generative_ai/google_generative_ai.dart';

// // import 'message_widget.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   late final GenerativeModel _model;
// //   final String apiKey = 'AIzaSyB8fMhva1VukHbLzM6cWHl8Ie_XCEnP0sU';
// //   final String backendUrl = 'https://amarillo-backend-production.up.railway.app/product/many';
// //   late final ChatSession _chatSession;
// //   final FocusNode _textFieldFocus = FocusNode();
// //   final TextEditingController _textController = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();
// //   final List<Map<String, String>> messages = [];
// //   bool _loading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _model = GenerativeModel(
// //       model: 'gemini-pro',
// //       apiKey: apiKey,
// //     );
// //     _chatSession = _model.startChat();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Chatbot con Gemini AI')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Expanded(
// //               child: ListView.builder(
// //                 controller: _scrollController,
// //                 itemCount: messages.length,
// //                 itemBuilder: (context, index) {
// //                   final message = messages[index];
// //                   return MessageWidget(
// //                     text: message["text"]!,
// //                     isFromUser: message["sender"] == "user",
// //                   );
// //                 },
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextField(
// //                       autofocus: true,
// //                       focusNode: _textFieldFocus,
// //                       decoration: textFieldDecoration(),
// //                       controller: _textController,
// //                       onSubmitted: (value) {
// //                         if (value.trim().isNotEmpty) {
// //                           _sendChatMessage(value.trim());
// //                         }
// //                       },
// //                     ),
// //                   ),
// //                   const SizedBox(width: 15),
// //                   IconButton(
// //                     icon: Icon(Icons.send),
// //                     onPressed: () {
// //                       final userMessage = _textController.text.trim();
// //                       if (userMessage.isNotEmpty) {
// //                         _sendChatMessage(userMessage);
// //                       }
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   InputDecoration textFieldDecoration() {
// //     return InputDecoration(
// //       contentPadding: const EdgeInsets.all(15),
// //       hintText: 'Escribe un mensaje...',
// //       border: OutlineInputBorder(
// //         borderRadius: const BorderRadius.all(
// //           Radius.circular(14),
// //         ),
// //         borderSide: BorderSide(
// //           color: Theme.of(context).colorScheme.secondary,
// //         ),
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderRadius: const BorderRadius.all(
// //           Radius.circular(14),
// //         ),
// //         borderSide: BorderSide(
// //           color: Theme.of(context).colorScheme.secondary,
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _sendChatMessage(String message) async {
// //     setState(() {
// //       messages.add({"sender": "user", "text": message});
// //       _loading = true;
// //     });

// //     try {
// //       final productsResponse = await http.get(Uri.parse(backendUrl), headers: {
// //         'Authorization':
// //             'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMyOTMwODJlLWQ4M2EtNDFlOC1hMDVlLTgzZDAwODRkNzMzYiIsImlhdCI6MTczNjk2MTcyOCwiZXhwIjoxNzM3MDQ4MTI4fQ.BOwr9QtDcykmgJ_sBuvb_F7TQHYXR8KUuFlSaJtiRt4',
// //       });

// //       if (productsResponse.statusCode != 200) {
// //         throw Exception("Error al obtener la lista de productos.");
// //       }

// //       final List products = jsonDecode(productsResponse.body);
// //       final filteredProducts = await _filterProducts(message, products);

// //       String botResponse;
// //       if (filteredProducts.isEmpty) {
// //         botResponse = "No encontré productos que coincidan con tu solicitud.";
// //       } else {
// //         botResponse = "Aquí tienes algunas sugerencias:\n";
// //         botResponse += filteredProducts
// //             .take(10)
// //             .map((p) => "${p['name']} - \$${p['price']}")
// //             .join("\n");
// //       }

// //       setState(() {
// //         messages.add({"sender": "bot", "text": botResponse});
// //         _loading = false;
// //         _scrollDown();
// //       });
// //     } catch (e) {
// //       _showError(e.toString());
// //     } finally {
// //       _textController.clear();
// //       _textFieldFocus.requestFocus();
// //     }
// //   }

// //   Future<List> _filterProducts(String userMessage, List products) async {
// //     final prompt =
// //         'El usuario dijo: "$userMessage". Aquí hay una lista de productos: ${products.map((p) => p['name']).join(', ')}. Selecciona los productos relevantes para la solicitud del usuario.';
// //     final responses = _model.generateContentStream([Content.text(prompt)]);
// //     print("Responses: $responses");
// //     await for (final response in responses) {
// //       print("response: $response");
// //       try {
// //         if (response.text != null && response.text!.startsWith('[')) {
// //           return jsonDecode(response.text!.trim());
// //         }
// //       } catch (e) {
// //         print('Error al procesar la respuesta: $e');
// //       }
// //     }
// //     return [];
// //   }

// //   void _scrollDown() {
// //     WidgetsBinding.instance.addPostFrameCallback(
// //       (_) => _scrollController.animateTo(
// //         _scrollController.position.maxScrollExtent,
// //         duration: const Duration(milliseconds: 750),
// //         curve: Curves.easeOutCirc,
// //       ),
// //     );
// //   }

// //   void _showError(String message) {
// //     showDialog<void>(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text('Algo salió mal'),
// //           content: SingleChildScrollView(
// //             child: SelectableText(message),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(),
// //               child: Text('Aceptar'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }
