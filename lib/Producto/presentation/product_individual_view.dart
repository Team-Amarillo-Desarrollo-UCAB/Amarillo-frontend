import 'package:flutter/material.dart';
import 'package:flutter_3d_viewer/flutter_3d_viewer.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';


class PerfumeDetailPage extends StatefulWidget {
  const PerfumeDetailPage({Key? key}) : super(key: key);

  @override
  State<PerfumeDetailPage> createState() => _PerfumeDetailPageState();
}

class _PerfumeDetailPageState extends State<PerfumeDetailPage> {
  bool isFavorite = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _media = [
    {
      'type': '3d', // Especifica que este es un modelo 3D.
      'src': 'assets/3d/Alcohol_Gel_Bottle_0114001746_texture.glb',
    },
    {
      'type': 'image', // Especifica que este es una imagen.
      'src': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-JcvdCWfmZ0XEtyscmk8wBpHATLPnqG.png',
    },
    {
      'type': 'image',
      'src': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-JcvdCWfmZ0XEtyscmk8wBpHATLPnqG.png',
    },
  ];

  final List<Map<String, dynamic>> similarProducts = [
    {
      'image': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-JcvdCWfmZ0XEtyscmk8wBpHATLPnqG.png',
      'name': 'N°5 L\'EAU',
    },
    {
      'image': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-JcvdCWfmZ0XEtyscmk8wBpHATLPnqG.png',
      'name': 'COCO',
    },
    {
      'image': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-JcvdCWfmZ0XEtyscmk8wBpHATLPnqG.png',
      'name': 'N°5',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildImageSlider(),
                    _buildProductInfo(),
                    _buildSimilarProducts(),
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

Widget _buildImageSlider() {
  return Stack(
    children: [
      SizedBox(
        height: 300,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: _media.length,
          itemBuilder: (context, index) {
            final item = _media[index];

            if (item['type'] == '3d') {
              // Renderiza el modelo 3D con ModelViewer
              return ModelViewer(
                src: item['src'], // Ruta al modelo .glb
                alt: "Modelo 3D",
                ar: true, // Habilita realidad aumentada (opcional)
                autoRotate: true,
                cameraControls: true,
              );
            } else {
              // Renderiza una imagen
              return Container(
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  item['src'],
                  fit: BoxFit.contain,
                ),
              );
            }
          },
        ),
      ),

        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _media.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.black
                      : Colors.grey.withOpacity(0.3),
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

  Widget _buildSimilarProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Similar this',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: similarProducts.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          similarProducts[index]['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      similarProducts[index]['name'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
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