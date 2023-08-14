import 'package:adminpanal/screens/categories/categories.dart';
import 'package:adminpanal/screens/homescreen/home_screen.dart';
import 'package:adminpanal/screens/user/user.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../providers/darkThemeProvider.dart';
import '../providers/cart_provider.dart';
import 'cart/cart_screen.dart';
import 'package:badges/badges.dart' as badges;

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _page = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {'page': CategoriesScreen(), 'title': 'Categories Screen'},
    {'page':  CartScreen(), 'title': ' Cart Screen'},
    {'page': const UserScreen(), 'title': 'User Screen'},
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
   // final cartProvider= Provider.of<CartProvider>(context);
    bool _isDark = themeState.getDarkTheme;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_page[_selectedIndex]['title']),
      // ),
      body: _page[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
        currentIndex: _selectedIndex,
        onTap: _selectedPage,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: _isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: _isDark ? Colors.lightBlue.shade200 : Colors.black87,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? IconlyBold.category
                  : IconlyLight.category),
              label: 'Categories'),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_,myCart,ch) {
                  return
                  badges.Badge(
                    badgeColor: Colors.deepPurple,
                    shape: BadgeShape.circle,
                    toAnimate: true,
                    position: badges.BadgePosition.topEnd(top: -10, end: -12),
                    showBadge: true,
                    borderRadius: BorderRadius.circular(8),
                    ignorePointer: false,
                    badgeContent: FittedBox(
                        child: TextWidget(
                            text: myCart.getCartItems.length.toString(),
                            color: Colors.white,
                            textSize: 15)),
                    child: Icon(
                        _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
                  );

                }
              ),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
              label: 'User'),
        ],
      ),
    );
  }
}
