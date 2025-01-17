import 'package:desarrollo_frontend/Producto/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_viewer/flutter_3d_viewer.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';


class PerfumeDetailPage extends StatefulWidget {
  final Product product;
  const PerfumeDetailPage({
    Key? key, required this.product
    }) : super(key: key);

  @override
  State<PerfumeDetailPage> createState() => _PerfumeDetailPageState();
}

class _PerfumeDetailPageState extends State<PerfumeDetailPage> {
  bool isFavorite = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;



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
                    _buildProductInfo(),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
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
          itemCount: product.image3d != null ? 1 : product.images.length, // Verifica cuántos elementos debe renderizar.
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            if (product.image3d != null && index == 0) {
              // Si hay imagen 3D, muestra el modelo en el primer slide.
              return ModelViewer(
                src: product.image3d!, // Ruta al modelo .glb
                alt: "Modelo 3D",
                ar: true, // Habilita realidad aumentada (opcional)
                autoRotate: true,
                cameraControls: true,
              );
            } else {
              // Si no hay imagen 3D, muestra las imágenes normales.
              return Container(
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  product.images[0],
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
            product.image3d != null ? 1 : product.images.length,
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
    ],
  );
}


  Widget _buildProductInfo() {
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
                children: const [
                  Text(
                    'Chanel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Eaude Toilette',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Text(
                '\$135.00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'N°5 L\'EAU is the N°5 of today. A vibrant abstract floral under the banner of modernity, with freshness as its core.',
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildBottomBar() {
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
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '+ Add To Cart',
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