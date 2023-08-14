import 'package:adminpanal/providers/darkThemeProvider.dart';
import 'package:adminpanal/inner_screen/feeds_screen.dart';
import 'package:adminpanal/inner_screen/on_sale_screen.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../business_logic/servies/globle_method.dart';
import '../../consts/constt.dart';
import '../../models/products_model.dart';
import '../../providers/products_providers.dart';
import '../../widgets/feed_items.dart';
import '../../widgets/on_sale_widget.dart';
import '../../widgets/price_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    //   GlobalMethod globalMethod=GlobalMethod();
    final ProductsProviders = Provider.of<ProductsProvider>(context);

    List<ProductModel> allProducts = ProductsProviders.getProducts;
    List<ProductModel> productsOnSale = ProductsProviders.getOnSaleProducts;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200.h,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Constss.offerImages[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: Constss.offerImages.length,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white, activeColor: Colors.red)),
                control: const SwiperControl(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            TextButton(
              onPressed: () {
                GlobalMethod.navigateTo(
                    ctx: context, routeName: OnSaleScreen.routeName);
              },
              child: TextWidget(
                text: 'View all',
                color: Colors.blue,
                textSize: 20.sp,
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      TextWidget(
                        text: 'On sale'.toUpperCase(),
                        color: Colors.red,
                        textSize: 22.sp,
                        isTitle: true,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Icon(
                        IconlyLight.discount,
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Flexible(
                  child: SizedBox(
                    height: 130.h,
                    child: ListView.builder(
                      itemCount: productsOnSale.length <10
                      ? productsOnSale.length
                      :10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: productsOnSale[index],
                            child: OnSaleWidget());
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextWidget(
                    text: 'Our products',
                    color: color,
                    textSize: 22.sp,
                    isTitle: true,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      GlobalMethod.navigateTo(
                          ctx: context, routeName: FeedsScreen.routeName);
                    },
                    child: TextWidget(
                        text: 'Browse all',
                        maxLines: 1,
                        color: Colors.blue,
                        textSize: 20.sp),
                  ),
                ],
              ),
            ),
            GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: .8.h,
              children: List.generate(
                  allProducts.length < 4 ? allProducts.length : 4, (index) {
                return ChangeNotifierProvider.value(
                  value: allProducts[index],
                    child: FeedsWidget());
              }),
            ),
          ],
        ),
      ),
    );
  }
}
