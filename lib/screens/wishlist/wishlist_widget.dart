import 'package:adminpanal/business_logic/servies/globle_method.dart';
import 'package:adminpanal/models/wishlist_model.dart';
import 'package:adminpanal/providers/wishlist_provider.dart';
import '../../inner_screen/product_details_screen.dart';
import 'package:adminpanal/widgets/heart_btm.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/darkThemeProvider.dart';
import '../../providers/products_providers.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductsProvider>(context);

    final wishlistModel = Provider.of<WishListModel>(context);
    final getCurrentProduct =
        productProvider.findProdById(wishlistModel.productId);

    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;

    final wishlistProvider = Provider.of<WishlistProvider>(context);


    bool? _isInWishList = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);





    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductsDetails.routeName,
          arguments: wishlistModel.productId
          );
          // GlobalMethod.navigateTo(
          //     ctx: context, routeName: ProductsDetails.routeName);
        },
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(.5),
            border: Border.all(color: color, width: 1.w),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: 65.w,
                  height: 80.h,
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(IconlyLight.bag2),
                          color: color,
                        ),
                        HeartBTN(
                          productId: getCurrentProduct.id,
                          isInWishList: _isInWishList,
                        ),
                      ],
                    ),
                     TextWidget(
                        text: getCurrentProduct.title,
                        color: color,
                        textSize: 18.sp,
                        isTitle: true,
                        maxLines: 1,

                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    TextWidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textSize: 22.sp,
                      isTitle: true,
                      maxLines: 2,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
