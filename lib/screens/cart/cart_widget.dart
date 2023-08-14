import 'package:adminpanal/providers/cart_provider.dart';
import 'package:adminpanal/providers/products_providers.dart';
import 'package:adminpanal/widgets/heart_btm.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/darkThemeProvider.dart';
import '../../business_logic/servies/globle_method.dart';
import '../../inner_screen/product_details_screen.dart';
import '../../models/cart_model.dart';
import '../../providers/wishlist_provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.q}) : super(key: key);
  final int q;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();

    super.initState();
  }

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
    final cartModel = Provider.of<CartModel>(context);
    final getCurrentProduct = productProvider.findProdById(cartModel.productId);

    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishListProvider = Provider.of<WishlistProvider>(context);

    bool? _isInWishList = wishListProvider.getWishlistItems.containsKey(getCurrentProduct.id);


    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductsDetails.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(
                      height: 60.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.imageUrl,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 6.h,
                        ),
                        TextWidget(
                          text: getCurrentProduct.title,
                          color: color,
                          textSize: 20,
                          isTitle: true,
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        SizedBox(
                          width: 100.w,
                          child: Row(
                            children: [
                              _quantityController(
                                  fct: () {
                                    if (_quantityTextController.text == '1') {
                                      return;
                                    } else {
                                      cartProvider.reduceQuantityByOne(
                                          cartModel.productId);

                                      setState(() {
                                        _quantityTextController.text =
                                            (int.parse(_quantityTextController
                                                        .text) -
                                                    1)
                                                .toString();
                                      });
                                    }
                                  },
                                  color: Colors.red,
                                  icon: CupertinoIcons.minus),
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  controller: _quantityTextController,
                                  keyboardType: TextInputType.number,
                                  // maxLength: 1,
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'))
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      if (v.isEmpty) {
                                        _quantityTextController.text = '1';
                                      } else {
                                        return;
                                      }
                                    });
                                  },
                                ),
                              ),
                              _quantityController(
                                  fct: () {
                                    cartProvider.increaseQuantityByOne(
                                        cartModel.productId);

                                    setState(() {
                                      _quantityTextController.text = (int.parse(
                                                  _quantityTextController
                                                      .text) +
                                              1)
                                          .toString();
                                    });
                                  },
                                  color: Colors.green,
                                  icon: CupertinoIcons.plus),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async{
                              await cartProvider.removeOneItem(
                                cartId: cartModel.id,
                                productId: cartModel.productId,
                                quantity: cartModel.quantity,

                              );
                            },
                            child: const Icon(
                              CupertinoIcons.cart_badge_minus,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          HeartBTN(
                            productId: getCurrentProduct.id,
                            isInWishList: _isInWishList,
                          ),
                          TextWidget(
                            text: '\$${(usedPrice*int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            color: color,
                            textSize: 18.sp,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityController({
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
