import 'package:firebase_auth/firebase_auth.dart';

import '../../inner_screen/product_details_screen.dart';
import 'package:adminpanal/providers/cart_provider.dart';
import 'package:adminpanal/widgets/price_widget.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/Viewed_prodProvider.dart';
import '../providers/darkThemeProvider.dart';
import '../business_logic/servies/globle_method.dart';
import '../business_logic/servies/utils.dart';
import '../consts/firebase_const.dart';
import '../models/products_model.dart';
import '../providers/wishlist_provider.dart';
import 'heart_btm.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({Key? key}) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;

    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishListProvider = Provider.of<WishlistProvider>(context);

    bool? _isInWishList =
        wishListProvider.getWishlistItems.containsKey(productModel.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            viewedProdProvider.addProductToHistory(productId: productModel.id);

            Navigator.pushNamed(context, ProductsDetails.routeName,
                arguments: productModel.id);

            // GlobalMethod.navigateTo(
            //     ctx: context, routeName: ProductsDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(children: [
            FancyShimmerImage(
              imageUrl: productModel.imageUrl,
              height: size.width * 0.16,
              width: size.width * 0.25,
              boxFit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: TextWidget(
                      text: productModel.title,
                      color: color,
                      maxLines: 1,
                      textSize: 18,
                      isTitle: true,
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: HeartBTN(
                        productId: productModel.id,
                        isInWishList: _isInWishList,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: PriceWidget(
                      salePrice: productModel.salePrice,
                      price: productModel.price,
                      textPrice: _quantityTextController.text,
                      isOnSale: productModel.isOnSale,
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 12,
                          child: FittedBox(
                            child: TextWidget(
                              text: productModel.isPiece ? 'Piece' : 'kg',
                              color: color,
                              textSize: 22,
                              isTitle: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            flex: 5,
                            // TextField can be used also instead of the textFormField
                            child: TextFormField(
                              controller: _quantityTextController,
                              key: const ValueKey('10'),
                              style: TextStyle(color: color, fontSize: 18),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              enabled: true,
                              onChanged: (valueee) {
                                setState(() {});
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'),
                                ),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _isInCart
                    ? null
                    : () async {
                        final User? user = authInstance.currentUser;
                        //  print( 'user id is ${user!.uid}');
                        if (user == null) {
                          GlobalMethod.errorDialog(
                              subTitle: 'No user found ,Please login first',
                              context: context);

                          return;
                        }
                        await GlobalMethod.addToCart(
                            productId: productModel.id,
                            context: context,
                            quantity:
                                int.parse(_quantityTextController.text));
                        await cartProvider.fetchCart();

                        // cartProvider.addProductsToCart(
                        //     productId: productModel.id,
                        //     quantity: int.parse(_quantityTextController.text));
                      },
                child: TextWidget(
                  text: _isInCart ? 'In cart ' : 'Add to cart',
                  maxLines: 1,
                  color: color,
                  textSize: 20,
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).cardColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    )),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
