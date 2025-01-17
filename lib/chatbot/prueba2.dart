import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '../common/infrastructure/tokenUser.dart';
import 'message_widget.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GenerativeModel _model;
  final String apiKey = 'AIzaSyB8fMhva1VukHbLzM6cWHl8Ie_XCEnP0sU';
  late final ChatSession _chatSession;
  final FocusNode _textFieldFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  final String backendUrl = 'https://amarillo-backend-production.up.railway.app/product/many';
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro', // El modelo de Google Generative AI
      apiKey: apiKey,
    );
    _chatSession = _model.startChat();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Godely Chatbot 🤖')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller:  _scrollController,
                itemCount: _chatSession.history.length,
                itemBuilder: (context, index) {
                  final Content content = _chatSession.history.toList()[index];
                  final text = content.parts.whereType<TextPart>().map<String>((e) => e.text).join('');
                  return MessageWidget(
                    text: text,
                    isFromUser: content.role == 'user',
                  );
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _textFieldFocus,
                      decoration: textFieldDecoration(),
                      controller: _textController,
                      onSubmitted: _sendChatMessage,
                    ),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      final message = _textController.text;
                      if (message.isNotEmpty) {
                        _sendChatMessage(message);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration textFieldDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'Escribe un mensaje...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

Future<List> fetchAllProducts() async {
  final token = await TokenUser().getToken();
  final List allProducts = [];
  int currentPage = 1;
  int perPage = 5;
  bool hasMore = true;

  while (hasMore) {
    final productsResponse = await http.get(
      Uri.parse('$backendUrl?page=$currentPage&perPage=$perPage'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (productsResponse.statusCode == 200) {
      final List products = jsonDecode(productsResponse.body);
      allProducts.addAll(products);
      
      // Si recibimos menos productos que perPage, significa que es la última página
      if (products.length < perPage) {
        hasMore = false;
      } else {
        currentPage++; // Si no es la última página, pasamos a la siguiente
      }
    } else {
      _showError('No se pudo obtener productos.');
      hasMore = false; // Detener el bucle si la solicitud falla
    }
  }

  return allProducts;
}

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      messages.add({"sender": "user", "text": message});
    });
    final token = await TokenUser().getToken();
    final productsResponse = await fetchAllProducts();

    if (productsResponse.isEmpty) {
      _showError('No se pudo obtener una respuesta');
    }
    print("response:" + productsResponse.toString());
    // Decodifica la lista de productos
    final List products = productsResponse;
    final prompt =
      'El usuario dijo: "$message". Aquí hay una lista de productos:${products.map((p) => "${p['name']}").join(', ')}.Selecciona los productos que sean relevantes para la solicitud del usuario. Genera una respuesta cálida y amigable para el usuario.';
    try{
      final response = await _chatSession.sendMessage(
        Content.text(prompt),
      );
      final text = response.text;
      if(text == null) {
        _showError('No se pudo obtener una respuesta');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  void _showError(String message) {
    showDialog<void>(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text('Algo salió mal'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}