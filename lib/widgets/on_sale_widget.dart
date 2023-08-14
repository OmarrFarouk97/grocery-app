// import 'package:adminpanal/widgets/price_widget.dart';
// import 'package:adminpanal/widgets/text_widgets.dart';
// import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../business_logic/global_cubit/darkThemeProvider.dart';
// import '../business_logic/servies/globle_method.dart';
// import '../../inner_screen/product_details_screen.dart';
// import '../consts/firebase_const.dart';
// import '../models/products_model.dart';
// import '../providers/cart_provider.dart';
// import '../providers/wishlist_provider.dart';
// import 'heart_btm.dart';
//
// class OnSaleWidget extends StatefulWidget {
//   const  OnSaleWidget({Key? key}) : super(key: key);
//
//   @override
//   State<OnSaleWidget> createState() => _OnSaleWidgetState();
// }
//
// class _OnSaleWidgetState extends State<OnSaleWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final themeState = Provider.of<DarkThemeProvider>(context);
//     final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
//     final productModel = Provider.of<ProductModel>(context);
//     final cartProvider = Provider.of<CartProvider>(context);
//     bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
//     final wishListProvider = Provider.of<WishlistProvider>(context);
//
//     bool? _isInWishList = wishListProvider.getWishlistItems.containsKey(productModel.id);
//
//     return Padding(
//       padding: EdgeInsets.all(6.0.h),
//       child: Material(
//         color: Theme.of(context).cardColor.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(12),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () {
//             Navigator.pushNamed(context, ProductsDetails.routeName,
//                 arguments: productModel.id);
//
//             //
//             // GlobalMethod.navigateTo(
//             //     ctx: context, routeName: ProductsDetails.routeName);
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FancyShimmerImage(
//                       imageUrl: productModel.imageUrl,
//                       height: 50.h,
//                       width: 60.w,
//                       boxFit: BoxFit.fill,
//                     ),
//                     // Image.network(
//                     //   'https://i.ibb.co/F0s3FHQ/Apricots.png',
//                     //   height: 30.h,
//                     //   fit: BoxFit.fill,
//                     // ),
//                     SizedBox(
//                       width: 10.h,
//                     ),
//                     Column(
//                       children: [
//                         TextWidget(
//                           text: productModel.isPiece ? '1Piece' : '1KG',
//                           color: color,
//                           textSize: 18.sp,
//                           isTitle: true,
//                         ),
//                         SizedBox(height: 8.h),
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: _isInCart
//                                   ? null
//                                   :() {
//                                 final User? user = authInstance.currentUser;
//                               //  print( 'user id is ${user!.uid}');
//                                 if (user == null){
//                                   GlobalMethod.errorDialog(subTitle: 'No user found ,Please login first', context: context);
//
//                                   return ;
//                                 }
//                                 cartProvider.addProductsToCart(
//                                     productId: productModel.id, quantity: 1);
//                               },
//                               child: Icon(
//                                 _isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
//                                 size: 22,
//                                 color: _isInCart ? Colors.green : color,
//                               ),
//                             ),
//                             HeartBTN(
//                               productId: productModel.id,
//                               isInWishList: _isInWishList,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 PriceWidget(
//                     salePrice: productModel.salePrice,
//                     price: productModel.price,
//                     textPrice: '1',
//                     isOnSale: true),
//                 SizedBox(
//                   height: 5.h,
//                 ),
//                 TextWidget(
//                   text: productModel.title,
//                   color: color,
//                   textSize: 16.sp,
//                   isTitle: true,
//                 ),
//                 SizedBox(
//                   height: 5.h,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:adminpanal/inner_screen/product_details_screen.dart';
import 'package:adminpanal/widgets/heart_btm.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../business_logic/servies/globle_method.dart';
import '../business_logic/servies/utils.dart';
import '../consts/firebase_const.dart';
import '../models/products_model.dart';
import '../providers/Viewed_prodProvider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'price_widget.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(productModel.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            viewedProdProvider.addProductToHistory(productId: productModel.id);

            Navigator.pushNamed(context, ProductsDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FancyShimmerImage(
                          imageUrl: productModel.imageUrl,
                          height: size.width * 0.22,
                          width: size.width * 0.22,
                          boxFit: BoxFit.fill,
                        ),
                        Column(
                          children: [
                            TextWidget(
                              text: productModel.isPiece ? '1Piece' : '1KG',
                              color: color,
                              textSize: 22,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _isInCart
                                      ? null
                                      : () async {
                                    final User? user =
                                        authInstance.currentUser;

                                    if (user == null) {
                                      GlobalMethod.errorDialog(
                                          subTitle:
                                          'No user found, Please login first',
                                          context: context);
                                      return;
                                    }
                                    await GlobalMethod.addToCart(
                                        productId: productModel.id,
                                        quantity: 1,
                                        context: context);
                                    await cartProvider.fetchCart();
                                    // cartProvider.addProductsToCart(
                                    //     productId: productModel.id,
                                    //     quantity: 1);
                                  },
                                  child: Icon(
                                    _isInCart
                                        ? IconlyBold.bag2
                                        : IconlyLight.bag2,
                                    size: 22,
                                    color: _isInCart ? Colors.green : color,
                                  ),
                                ),
                                HeartBTN(
                                  productId: productModel.id,
                                  isInWishList:_isInWishlist ,
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    PriceWidget(
                      salePrice: productModel.salePrice,
                      price: productModel.price,
                      textPrice: '1',
                      isOnSale: true,
                    ),
                    const SizedBox(height: 5),
                    TextWidget(
                      text: productModel.title,
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    const SizedBox(height: 5),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
