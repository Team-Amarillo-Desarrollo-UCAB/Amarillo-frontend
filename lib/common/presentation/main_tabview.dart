import 'package:desarrollo_frontend/Producto/presentation/product_view.dart';
import 'package:flutter/material.dart';
import '../../Users/presentation/profile_screen.dart';
import '../../Carrito/presentation/cart_screen.dart';
import 'color_extension.dart';
import 'common_widget/tab_button.dart';
import '../../home/presentation/home_view.dart';
import '../../order/presentation/order_history_active.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selctTab = 2;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const HomeView();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final userProfile = Provider.of<UserProfile>(context, listen: false);
  //   userProfile.reloadFromPreferences();
  // }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: PageStorage(bucket: storageBucket, child: selectPageView),
      backgroundColor: const Color(0xfff5f5f5),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: TColor.white,
        shadowColor: Colors.black,
        elevation: 1,
        notchMargin: media.height * 0.01,
        height: media.height * 0.1,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                title: "Inicio",
                icon: Icons.home,
                onTap: () {
                  if (selctTab != 2) {
                    selctTab = 2;
                    selectPageView = const HomeView();
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                isSelected: selctTab == 2,
              ),
              TabButton(
                title: "Catálogo",
                icon: Icons.search,
                onTap: () {
                  if (selctTab != 0) {
                    selctTab = 0;
                    selectPageView = const ProductView();
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                isSelected: selctTab == 0,
              ),
              TabButton(
                title: "Carrito",
                icon: Icons.shopping_cart,
                onTap: () {
                  if (selctTab != 1) {
                    selctTab = 1;
                    selectPageView = const CartScreen();
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                isSelected: selctTab == 1,
              ),
              TabButton(
                title: "Historial",
                icon: Icons.library_books,
                onTap: () {
                  if (selctTab != 3) {
                    selctTab = 3;
                    selectPageView = OrderHistoryScreen();
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                isSelected: selctTab == 3,
              ),
              TabButton(
                title: "Perfil",
                icon: Icons.person,
                onTap: () {
                  if (selctTab != 4) {
                    selctTab = 4;
                    selectPageView = const UserProfileScreen();
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                isSelected: selctTab == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
