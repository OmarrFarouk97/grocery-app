import 'package:adminpanal/widgets/heart_btm.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/darkThemeProvider.dart';
import '../business_logic/servies/globle_method.dart';
import '../consts/firebase_const.dart';
import '../providers/Viewed_prodProvider.dart';
import '../providers/cart_provider.dart';
import '../providers/products_providers.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/back_widget.dart';

class ProductsDetails extends StatefulWidget {
  static const routeName = "/ProductScreenState";

  const ProductsDetails({Key? key}) : super(key: key);

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findProdById(productId);

    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);

    final wishListProvider = Provider.of<WishlistProvider>(context);

    bool? _isInWishList =
        wishListProvider.getWishlistItems.containsKey(getCurrentProduct.id);

    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    return WillPopScope(
      onWillPop: () async {
       // viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: FancyShimmerImage(
                imageUrl: getCurrentProduct.imageUrl,
                height: 220.h,
                width: 140.w,
                boxFit: BoxFit.fill,
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextWidget(
                              text: getCurrentProduct.title,
                              color: color,
                              textSize: 25.sp,
                              isTitle: true,
                            ),
                          ),
                          HeartBTN(
                            productId: getCurrentProduct.id,
                            isInWishList: _isInWishList,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: '\$${usedPrice.toStringAsFixed(2)}/',
                            color: Colors.green,
                            textSize: 22,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: getCurrentProduct.isPiece ? 'Piece' : '/KG',
                            color: Colors.green,
                            textSize: 22,
                            isTitle: false,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Visibility(
                            visible: getCurrentProduct.isOnSale ? true : false,
                            child: Text(
                              '\$${getCurrentProduct.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: color,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(63, 200, 101, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextWidget(
                              text: 'Free delivery',
                              color: Colors.white,
                              textSize: 18.sp,
                              isTitle: true,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        quantityController(
                            fct: () {
                              if (_quantityTextController.text == '1') {
                                return;
                              } else {
                                setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) -
                                              1)
                                          .toString();
                                });
                              }
                            },
                            icon: CupertinoIcons.minus,
                            color: Colors.red),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _quantityTextController,
                            key: const ValueKey('quantity'),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.green,
                            enabled: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(
                                  '[0-9]',
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  _quantityTextController.text = '1';
                                } else {}
                              });
                            },
                          ),
                        ),
                        quantityController(
                            fct: () {
                              setState(() {
                                _quantityTextController.text =
                                    (int.parse(_quantityTextController.text) +
                                            1)
                                        .toString();
                              });
                            },
                            icon: CupertinoIcons.plus,
                            color: Colors.green),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'Total',
                                  color: Colors.red.shade300,
                                  textSize: 20.sp,
                                  isTitle: true,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        text:
                                            '\$${totalPrice.toStringAsFixed(2)}/',
                                        color: color,
                                        textSize: 20.sp,
                                        isTitle: true,
                                      ),
                                      TextWidget(
                                        text:
                                            '${_quantityTextController.text}Kg',
                                        color: color,
                                        textSize: 16.sp,
                                        isTitle: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Flexible(
                              child: Material(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: _isInCart
                                  ? null
                                  : () async{
                                      final User? user =
                                          authInstance.currentUser;
                                      print('user id is ${user!.uid}');
                                      if (user == null) {
                                        GlobalMethod.errorDialog(
                                            subTitle:
                                                'No user found ,Please login first',
                                            context: context);

                                        return;
                                      }
                                    await  GlobalMethod.addToCart(productId: getCurrentProduct.id, context: context,quantity: int.parse(
                                          _quantityTextController.text));
                                      await cartProvider.fetchCart();


                                // cartProvider.addProductsToCart(
                                      //     productId: getCurrentProduct.id,
                                      //     quantity: int.parse(
                                      //         _quantityTextController.text));
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextWidget(
                                    text: _isInCart ? 'In cart' : 'Add to cart',
                                    color: Colors.white,
                                    textSize: 18.sp),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
