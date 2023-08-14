import 'package:adminpanal/models/viewed_model.dart';
import 'package:adminpanal/providers/Viewed_prodProvider.dart';
import 'package:adminpanal/providers/cart_provider.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/darkThemeProvider.dart';
import '../../business_logic/servies/globle_method.dart';
import '../../consts/firebase_const.dart';
import '../../inner_screen/product_details_screen.dart';
import '../../providers/products_providers.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  State<ViewedRecentlyWidget> createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {


  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final productProvider = Provider.of<ProductsProvider>(context);

    final viewedProdModel = Provider.of<ViewedProdModel>(context);


    final getCurrentProduct =
    productProvider.findProdById(viewedProdModel.productId);

    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;

    final cartProvider =Provider.of<CartProvider>(context);
    bool? _isInCart= cartProvider.getCartItems.containsKey(getCurrentProduct.id);

    return GestureDetector(
      onTap: () {
        // GlobalMethod.navigateTo(
        //     ctx: context, routeName: ProductsDetails.routeName);
      },
      child: Row(



        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FancyShimmerImage(
            imageUrl: getCurrentProduct.imageUrl,
            boxFit: BoxFit.fill,
            height: 90.h,
            width: 70.w,
          ),
          SizedBox(
            width: 12.w,
          ),
          Column(
            children: [
              TextWidget(
                text: getCurrentProduct.title,
                color: color,
                textSize: 24,
                isTitle: true,
              ),
              SizedBox(
                height: 12.h,
              ),
              TextWidget(
                text: '\$${usedPrice.toStringAsFixed(2)}',
                color: color,
                textSize: 20.sp,
                isTitle: false,
              ),

            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.green,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _isInCart
                    ? null
                    :()async {
                  final User? user = authInstance.currentUser;
                  //print( 'user id is ${user!.uid}');
                  if (user == null){
                    GlobalMethod.errorDialog(subTitle: 'No user found ,Please login first', context: context);

                    return ;
                  }
                 await GlobalMethod.addToCart(productId: getCurrentProduct.id, context: context,quantity: 1);
                  await cartProvider.fetchCart();


                  // cartProvider.addProductsToCart(
                  //     productId: getCurrentProduct.id, quantity: 1);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    _isInCart
                    ? Icons.check
                    : IconlyBold.plus ,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
