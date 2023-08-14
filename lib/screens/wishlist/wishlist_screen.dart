import 'package:adminpanal/providers/wishlist_provider.dart';
import 'package:adminpanal/screens/wishlist/wishlist_widget.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../providers/darkThemeProvider.dart';
import '../../business_logic/servies/globle_method.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../cart/cart_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";

  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    bool _isEmpty = true;

    final wishListProvider = Provider.of<WishlistProvider>(context);

    final wishListItemsList =
        wishListProvider.getWishlistItems.values.toList().reversed.toList();

    return wishListItemsList.isEmpty
        ? const EmptyScreen(
            title: "Your wishlist is empty",
            subTitle: 'Explore more and shortlist some items',
            imagePath: "assets/images/wishlist.png",
            buttonText: 'Add a wish',
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const BackWidget(),
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Wishlist (${wishListItemsList.length})',
                color: color,
                textSize: 22.sp,
                isTitle: true,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethod.warningDialog(
                          title: 'Empty your wishlist',
                          subTitle: 'are you sure?',
                          fct: ()async {
                            await wishListProvider.clearOnlineWishlist();
                            wishListProvider.clearLocalWishlist();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ))
              ],
            ),
            body: MasonryGridView.count(
              itemCount: wishListItemsList.length,
              crossAxisCount: 2,
              // mainAxisSpacing: 4,
              // crossAxisSpacing: 4,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: wishListItemsList[index],
                    child: const WishlistWidget());
              },
            ));
  }
}
