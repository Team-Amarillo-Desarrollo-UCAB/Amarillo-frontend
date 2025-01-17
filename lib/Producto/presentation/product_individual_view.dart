import 'package:desarrollo_frontend/Carrito/application/cart_useCase.dart';
import 'package:desarrollo_frontend/Carrito/domain/cart_item.dart';
import 'package:desarrollo_frontend/Producto/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_viewer/flutter_3d_viewer.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../common/presentation/color_extension.dart';

class PerfumeDetailPage extends StatefulWidget {
  final Product product;
  const PerfumeDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<PerfumeDetailPage> createState() => _PerfumeDetailPageState();
}

class _PerfumeDetailPageState extends State<PerfumeDetailPage> {
  bool isFavorite = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _show3D = false;
  final CartUsecase _cartUsecase = CartUsecase();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSlider(product),
                    _buildProductInfo(product),
                  ],
                ),
              ),
            ),
            _buildBottomBar(product),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(Product product) {
  return Stack(
    children: [
      SizedBox(
        height: 300,
        child: PageView.builder(
          controller: _pageController,
          itemCount: 1, 
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            if (_show3D && product.image3d != '') {
              return ModelViewer(
                src: product.image3d!, 
                alt: "Modelo 3D",
                ar: true, 
                autoRotate: true,
                cameraControls: true,
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Image.network(
                    (product.images[0] as NetworkImage).url,
                    fit: BoxFit.contain,
                  ),
              );
            }
          },
        ),
      ),
      Positioned(
        bottom: 10,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            1,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ),
      if (product.image3d != '')
        Positioned(
          top: 10,
          right: 10,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _show3D = !_show3D; 
              });
            },
            child: Text(_show3D ? "Ver imagen 2D" : "Ver imagen 3D"),
          ),
        ),
    ],
  );
}


  Widget _buildProductInfo(Product product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.peso,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                product.price,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Product product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _cartUsecase.onAddCart(
                    CartItem(
                      id_product: product.id_product,
                      imageUrl: product.images[0],
                      name: product.name,
                      price: double.parse(product.price),
                      description: product.description,
                      peso: product.peso,
                      isCombo: false,
                      discount: product.discount,
                      category: product.category,
                    ),
                    context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Añadir al carrito',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



//-----------------------------------


// class PerfumeDetailPage extends StatefulWidget {
//   const PerfumeDetailPage({Key? key}) : super(key: key);

//   @override
//   State<PerfumeDetailPage> createState() => _PerfumeDetailPageState();
// }

// class _PerfumeDetailPageState extends State<PerfumeDetailPage> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 226, 203, 54),
//       body: ModelViewer(
//         src: 'assets/3d/Alcohol_Gel_Bottle_0114001746_texture.glb',
//         // alt: "Modelo 3D",
//         // ar: true, // Habilita realidad aumentada (opcional)
//         // autoRotate: true,
//         // cameraControls: true,
//       ),
//     );
//   }

// }