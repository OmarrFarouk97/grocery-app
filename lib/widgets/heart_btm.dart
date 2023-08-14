import 'package:adminpanal/business_logic/servies/globle_method.dart';
import 'package:adminpanal/consts/firebase_const.dart';
import 'package:adminpanal/providers/wishlist_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/darkThemeProvider.dart';
import '../business_logic/servies/utils.dart';
import '../providers/cart_provider.dart';
import '../providers/products_providers.dart';

class HeartBTN extends StatefulWidget {
  const HeartBTN({Key? key, required this.productId, this.isInWishList = false})
      : super(key: key);
  final String productId;
  final bool? isInWishList;

  @override
  State<HeartBTN> createState() => _HeartBTNState();
}

class _HeartBTNState extends State<HeartBTN> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);

    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
   // final Color color = Utils(context).color;

    return GestureDetector(
      onTap: () async {
      setState(() {
        loading = true;
      });
      try {
        final User? user = authInstance.currentUser;

        if (user == null) {
          GlobalMethod.errorDialog(
              subTitle: 'No user found, Please login first',
              context: context);
          return;
        }
        if (widget.isInWishList == false && widget.isInWishList != null) {
          await GlobalMethod.addToWishlist(
              productId: widget.productId, context: context);
        } else {
          await wishlistProvider.removeOneItem(
              wishlistId:
              wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
              productId: widget.productId);
        }
        await wishlistProvider.fetchWishlist();
        setState(() {
          loading = false;
        });
      } catch (error) {
        GlobalMethod.errorDialog(subTitle: '$error', context: context);
      } finally {
        setState(() {
          loading = false;
        });
      }
      },
      child: Icon(
        widget.isInWishList !=null && widget.isInWishList==true ? IconlyBold.heart : IconlyLight.heart,
        size: 22,
        color: widget.isInWishList !=null && widget.isInWishList==true ? Colors.red : color,
      ),
    );
  }
}
