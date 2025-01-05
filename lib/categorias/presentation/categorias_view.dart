import 'package:desarrollo_frontend/categorias/domain/category.dart';
import 'package:desarrollo_frontend/categorias/infrasestructure/category_service.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:flutter/material.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/category_cell.dart';
import '../../common/presentation/common_widget/title_only.dart';
import 'category_items_view.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});
  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<Category> _categories = [];
  TextEditingController _searchController = TextEditingController();
  final CategoryService _categoryService = CategoryService(BaseUrl().BASE_URL);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Category> categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
      });
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error al obtener categorías: $error');
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.centerLeft,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 46,
                        ),
                        Text(
                          "Categorias",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Productos, Categorías...",
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.orange),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.orange.withOpacity(0.1),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductListView(searchQuery: value.trim()),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/img/oferta2.png',
                      width: 400,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TitleOnly(
                      title: "Todas las categorías",
                      onView: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 120,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemCount: _categories.length,
                            itemBuilder: ((context, index) {
                              final category = _categories[index];
                              return CategoryCell(
                                cObj: {
                                  'image': category.categoryImage,
                                  'name': category.categoryName,
                                  'id': category.categoryID,
                                },
                                onTap: () {},
                              );
                            }),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
